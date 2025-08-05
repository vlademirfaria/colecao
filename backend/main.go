// backend/main.go
package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

// Item representa a estrutura de um item da coleção
type Item struct {
	ID               int            `json:"id"`
	Tipo             string         `json:"tipo"`
	TituloPortugues  string         `json:"titulo_portugues"`
	TituloOriginal   sql.NullString `json:"titulo_original"`
	Autor            sql.NullString `json:"autor"`
	Desenhista       sql.NullString `json:"desenhista"`
	ISBN             sql.NullString `json:"isbn"`
	Editora          sql.NullString `json:"editora"`
	Ano              sql.NullInt64  `json:"ano"`
	Idioma           sql.NullString `json:"idioma"`
	Edicao           sql.NullString `json:"edicao"`
}

// PaginatedResponse é a estrutura para a resposta paginada
type PaginatedResponse struct {
	Items []Item `json:"items"`
	Total int    `json:"total"`
	Page  int    `json:"page"`
	Limit int    `json:"limit"`
}

var db *sql.DB

func connectDB() {
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	dbname := os.Getenv("DB_NAME")
	host := os.Getenv("DB_HOST")
	port := os.Getenv("DB_PORT")

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true&charset=utf8mb4", user, password, host, port, dbname)
	
	var err error
	maxRetries := 10
	for i := 0; i < maxRetries; i++ {
		db, err = sql.Open("mysql", dsn)
		if err != nil {
			log.Fatalf("Falha ao abrir conexão com a base de dados: %v", err)
		}
		err = db.Ping()
		if err == nil {
			fmt.Println("Conexão com a base de dados MySQL estabelecida com sucesso!")
			return
		}
		log.Printf("Falha ao conectar com a base de dados (tentativa %d/%d): %v", i+1, maxRetries, err)
		time.Sleep(5 * time.Second)
	}
	log.Fatal("Não foi possível conectar à base de dados após várias tentativas. Desistindo.")
}

func setJSONHeader(w http.ResponseWriter) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
}

func itemsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
    w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
    w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	if r.Method == "OPTIONS" {
        w.WriteHeader(http.StatusOK)
        return
    }
	switch r.Method {
	case "GET":
		getItems(w, r)
	case "POST":
		createItem(w, r)
	default:
		http.Error(w, "Método não permitido", http.StatusMethodNotAllowed)
	}
}

func itemHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
    w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
    w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
    if r.Method == "OPTIONS" {
        w.WriteHeader(http.StatusOK)
        return
    }
	idStr := strings.TrimPrefix(r.URL.Path, "/api/items/")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "ID inválido", http.StatusBadRequest)
		return
	}
	switch r.Method {
	// ATUALIZADO: Adicionado o método GET para buscar um item específico
	case "GET":
		getItem(w, r, id)
	case "PUT":
		updateItem(w, r, id)
	case "DELETE":
		deleteItem(w, r, id)
	default:
		http.Error(w, "Método não permitido", http.StatusMethodNotAllowed)
	}
}

// ATUALIZADO: Nova função para buscar um único item por ID
func getItem(w http.ResponseWriter, r *http.Request, id int) {
	var i Item
	query := "SELECT id, tipo, titulo_portugues, titulo_original, autor, desenhista, isbn, editora, ano, idioma, edicao FROM itens WHERE id = ?"
	err := db.QueryRow(query, id).Scan(&i.ID, &i.Tipo, &i.TituloPortugues, &i.TituloOriginal, &i.Autor, &i.Desenhista, &i.ISBN, &i.Editora, &i.Ano, &i.Idioma, &i.Edicao)
	if err != nil {
		if err == sql.ErrNoRows {
			http.Error(w, "Item não encontrado", http.StatusNotFound)
		} else {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
		return
	}
	setJSONHeader(w)
	json.NewEncoder(w).Encode(i)
}

func getItems(w http.ResponseWriter, r *http.Request) {
	filters := r.URL.Query()
	
	page, _ := strconv.Atoi(filters.Get("page"))
	if page < 1 {
		page = 1
	}
	limit, _ := strconv.Atoi(filters.Get("limit"))
	if limit <= 0 {
		limit = 10
	}
	offset := (page - 1) * limit

	whereClause := ""
	conditions := []string{}
	args := []interface{}{}

    filterMap := map[string]string{
        "titulo_portugues": "titulo_portugues", "autor": "autor", "editora": "editora",
        "isbn": "isbn", "ano": "ano", "idioma": "idioma", "edicao": "edicao", "tipo": "tipo",
    }
    
    for param, column := range filterMap {
        if value := filters.Get(param); value != "" {
            if param == "ano" || param == "tipo" {
                conditions = append(conditions, fmt.Sprintf("`%s` = ?", column))
                args = append(args, value)
            } else {
                conditions = append(conditions, fmt.Sprintf("`%s` LIKE ?", column))
                args = append(args, "%"+value+"%")
            }
        }
    }

	if len(conditions) > 0 {
		whereClause = " WHERE " + strings.Join(conditions, " AND ")
	}

	var total int
	countQuery := "SELECT COUNT(*) FROM itens" + whereClause
	err := db.QueryRow(countQuery, args...).Scan(&total)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	orderBy := " ORDER BY titulo_portugues ASC"
	if sortBy := filters.Get("sortBy"); sortBy != "" {
		switch sortBy {
		case "title_desc":
			orderBy = " ORDER BY titulo_portugues DESC"
		case "year_desc":
			orderBy = " ORDER BY ano DESC, titulo_portugues ASC"
		case "year_asc":
			orderBy = " ORDER BY ano ASC, titulo_portugues ASC"
		}
	}

	query := "SELECT id, tipo, titulo_portugues, titulo_original, autor, desenhista, isbn, editora, ano, idioma, edicao FROM itens" + whereClause + orderBy + " LIMIT ? OFFSET ?"
	
	pagedArgs := append(args, limit, offset)

	rows, err := db.Query(query, pagedArgs...)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	items := []Item{}
	for rows.Next() {
		var i Item
		err := rows.Scan(&i.ID, &i.Tipo, &i.TituloPortugues, &i.TituloOriginal, &i.Autor, &i.Desenhista, &i.ISBN, &i.Editora, &i.Ano, &i.Idioma, &i.Edicao)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		items = append(items, i)
	}

	response := PaginatedResponse{
		Items: items,
		Total: total,
		Page:  page,
		Limit: limit,
	}

	setJSONHeader(w)
	json.NewEncoder(w).Encode(response)
}

func createItem(w http.ResponseWriter, r *http.Request) {
	var i Item
	if err := json.NewDecoder(r.Body).Decode(&i); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	query := `INSERT INTO itens (tipo, titulo_portugues, titulo_original, autor, desenhista, isbn, editora, ano, idioma, edicao) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
	result, err := db.Exec(query, i.Tipo, i.TituloPortugues, i.TituloOriginal, i.Autor, i.Desenhista, i.ISBN, i.Editora, i.Ano, i.Idioma, i.Edicao)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	id, err := result.LastInsertId()
    if err != nil {
        http.Error(w, "Erro ao obter o ID do item inserido", http.StatusInternalServerError)
        return
    }
    i.ID = int(id)
	setJSONHeader(w)
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(i)
}

func updateItem(w http.ResponseWriter, r *http.Request, id int) {
	var i Item
	if err := json.NewDecoder(r.Body).Decode(&i); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	query := `UPDATE itens SET tipo=?, titulo_portugues=?, titulo_original=?, autor=?, desenhista=?, isbn=?, editora=?, ano=?, idioma=?, edicao=? WHERE id=?`
	_, err := db.Exec(query, i.Tipo, i.TituloPortugues, i.TituloOriginal, i.Autor, i.Desenhista, i.ISBN, i.Editora, i.Ano, i.Idioma, i.Edicao, id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	setJSONHeader(w)
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(i)
}

func deleteItem(w http.ResponseWriter, r *http.Request, id int) {
	query := `DELETE FROM itens WHERE id=?`
	_, err := db.Exec(query, id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

func main() {
	connectDB()
	defer db.Close()
    fs := http.FileServer(http.Dir("./frontend"))
    http.Handle("/", fs)
	http.HandleFunc("/api/items", itemsHandler)
	http.HandleFunc("/api/items/", itemHandler)
	log.Println("Servidor iniciado na porta 8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}
