// frontend/script.js

// Constantes para elementos do DOM
const apiUrl = '/api/items';
const form = document.getElementById('item-form');
const formTitle = document.getElementById('form-title');
const itemsList = document.getElementById('items-list');
const loadingIndicator = document.getElementById('loading');
const emptyMessage = document.getElementById('empty-message');
const cancelBtn = document.getElementById('cancel-btn');
const tipoSelect = document.getElementById('tipo');
const desenhistaField = document.getElementById('desenhista-field');
const formMessage = document.getElementById('form-message');
const filterForm = document.getElementById('filter-form');
const clearFiltersBtn = document.getElementById('clear-filters-btn');
const paginationControls = document.getElementById('pagination-controls');
const itemCountSpan = document.getElementById('item-count');

// Variáveis de estado
let currentPage = 1;
const itemsPerPage = 10;
let currentFilters = new URLSearchParams();

/**
 * Exibe uma mensagem no formulário (sucesso ou erro).
 * @param {string} message - A mensagem a ser exibida.
 * @param {boolean} isError - Se a mensagem é de erro.
 */
const showFormMessage = (message, isError = false) => {
    formMessage.textContent = message;
    formMessage.className = `p-3 text-sm rounded-lg ${isError ? 'text-red-800 bg-red-50' : 'text-green-800 bg-green-50'}`;
    formMessage.classList.remove('hidden');
};

/**
 * Oculta a mensagem do formulário.
 */
const hideFormMessage = () => formMessage.classList.add('hidden');

/**
 * Alterna a visibilidade do campo "Desenhista" com base no tipo de item.
 */
const toggleDesenhistaField = () => {
    desenhistaField.style.display = tipoSelect.value === 'gibi' ? 'block' : 'none';
};

/**
 * Renderiza os controles de paginação.
 * @param {number} total - O número total de itens.
 * @param {number} page - A página atual.
 * @param {number} limit - O número de itens por página.
 */
const renderPagination = (total, page, limit) => {
    paginationControls.innerHTML = '';
    const totalPages = Math.ceil(total / limit);
    if (totalPages <= 1) {
        itemCountSpan.textContent = total > 0 ? `Mostrando ${total} de ${total} itens` : '';
        return;
    }
    
    const startItem = (page - 1) * limit + 1;
    const endItem = Math.min(page * limit, total);
    itemCountSpan.textContent = `Mostrando ${startItem}-${endItem} de ${total} itens`;

    const createButton = (text, onClick, disabled = false) => {
        const button = document.createElement('button');
        button.textContent = text;
        button.disabled = disabled;
        button.className = 'px-3 py-1 border rounded-md bg-white hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed';
        button.onclick = onClick;
        return button;
    };

    paginationControls.appendChild(createButton('Anterior', () => fetchItems(page - 1), page === 1));

    for (let i = 1; i <= totalPages; i++) {
        const pageButton = createButton(i, () => fetchItems(i));
        if (i === page) {
            pageButton.classList.add('pagination-active');
        }
        paginationControls.appendChild(pageButton);
    }

    paginationControls.appendChild(createButton('Próxima', () => fetchItems(page + 1), page === totalPages));
};

/**
 * Busca e exibe os itens da API.
 * @param {number} page - O número da página a ser buscada.
 */
const fetchItems = async (page = 1) => {
    currentPage = page;
    loadingIndicator.style.display = 'flex';
    itemsList.style.display = 'none';
    emptyMessage.style.display = 'none';
    paginationControls.innerHTML = '';
    itemCountSpan.textContent = '';

    const params = new URLSearchParams(currentFilters);
    params.set('page', page);
    params.set('limit', itemsPerPage);

    try {
        const response = await fetch(`${apiUrl}?${params.toString()}`);
        if (!response.ok) throw new Error(`Erro do servidor: ${response.status}`);
        
        const data = await response.json();
        const { items, total, limit } = data;
        
        itemsList.innerHTML = '';

        if (!items || items.length === 0) {
            emptyMessage.style.display = 'block';
        } else {
            items.forEach(item => {
                const itemElement = document.createElement('div');
                itemElement.className = 'p-4 border rounded-lg bg-gray-50';
                itemElement.innerHTML = `
                    <div class="flex justify-between items-start flex-wrap">
                        <div class="flex-grow mb-2 sm:mb-0 pr-4">
                            <p class="font-bold text-lg text-gray-800">${item.titulo_portugues} <span class="text-sm font-normal text-white ${item.tipo === 'livro' ? 'bg-green-500' : 'bg-purple-500'} px-2 py-0.5 rounded-full">${item.tipo}</span></p>
                            <p class="text-sm text-gray-600">${item.autor?.String || 'N/A'}</p>
                            <p class="text-xs text-gray-500">${item.editora?.String || 'N/A'} - ${item.ano?.Int64 || 'N/A'}</p>
                        </div>
                        <div class="flex space-x-2 flex-shrink-0">
                            <button onclick="editItem(${item.id})" class="bg-yellow-500 text-white px-3 py-1 rounded-md text-sm hover:bg-yellow-600">Editar</button>
                            <button onclick="deleteItem(${item.id})" class="bg-red-600 text-white px-3 py-1 rounded-md text-sm hover:bg-red-700">Excluir</button>
                        </div>
                    </div>
                    <details class="mt-3">
                        <summary class="cursor-pointer text-sm text-indigo-600 hover:text-indigo-800">Ver mais</summary>
                        <div class="mt-2 pt-2 border-t text-sm text-gray-700 space-y-1">
                            <p><strong>Título Original:</strong> ${item.titulo_original?.String || 'N/A'}</p>
                            ${item.tipo === 'gibi' ? `<p><strong>Desenhista:</strong> ${item.desenhista?.String || 'N/A'}</p>` : ''}
                            <p><strong>Edição:</strong> ${item.edicao?.String || 'N/A'}</p>
                            <p><strong>Idioma:</strong> ${item.idioma?.String || 'N/A'}</p>
                            <p><strong>ISBN:</strong> ${item.isbn?.String || 'N/A'}</p>
                        </div>
                    </details>
                `;
                itemsList.appendChild(itemElement);
            });
            itemsList.style.display = 'block';
            renderPagination(total, page, limit);
        }
    } catch (error) {
        console.error('Erro:', error);
        emptyMessage.textContent = error.message;
        emptyMessage.style.display = 'block';
    } finally {
        loadingIndicator.style.display = 'none';
    }
};

/**
 * Prepara o formulário para edição de um item.
 * @param {number} id - O ID do item a ser editado.
 */
const editItem = async (id) => {
    hideFormMessage();
    try {
        const response = await fetch(`${apiUrl}/${id}`);
        if (!response.ok) throw new Error('Não foi possível carregar os dados do item para edição.');
        
        const item = await response.json();

        document.getElementById('item-id').value = item.id;
        document.getElementById('tipo').value = item.tipo;
        document.getElementById('titulo_portugues').value = item.titulo_portugues;
        document.getElementById('titulo_original').value = item.titulo_original.String || '';
        document.getElementById('autor').value = item.autor.String || '';
        document.getElementById('desenhista').value = item.desenhista.String || '';
        document.getElementById('editora').value = item.editora.String || '';
        document.getElementById('ano').value = item.ano.Int64 || '';
        document.getElementById('edicao').value = item.edicao.String || '';
        document.getElementById('isbn').value = item.isbn.String || '';
        document.getElementById('idioma').value = item.idioma.String || '';
        
        formTitle.textContent = 'Editar Item';
        cancelBtn.style.display = 'block';
        toggleDesenhistaField();
        window.scrollTo({ top: 0, behavior: 'smooth' });
    } catch (error) {
        console.error('Erro ao preparar edição:', error);
        alert(error.message);
    }
};

/**
 * Exclui um item.
 * @param {number} id - O ID do item a ser excluído.
 */
const deleteItem = async (id) => {
    if (!confirm('Tem certeza que deseja excluir este item?')) return;
    try {
        const response = await fetch(`${apiUrl}/${id}`, { method: 'DELETE' });
        if (!response.ok) throw new Error('Falha ao excluir');
        fetchItems(currentPage);
    } catch (error) {
        console.error('Erro ao excluir:', error);
        alert(`Não foi possível excluir o item: ${error.message}`);
    }
};

/**
 * Reseta o formulário de adição/edição.
 */
const resetForm = () => {
    form.reset();
    document.getElementById('item-id').value = '';
    formTitle.textContent = 'Adicionar Novo Item';
    cancelBtn.style.display = 'none';
    toggleDesenhistaField();
};

// --- Event Listeners ---

tipoSelect.addEventListener('change', toggleDesenhistaField);
cancelBtn.addEventListener('click', () => {
    resetForm();
    hideFormMessage();
});

form.addEventListener('submit', async (e) => {
    e.preventDefault();
    hideFormMessage();
    const id = document.getElementById('item-id').value;
    const itemData = {
        tipo: document.getElementById('tipo').value,
        titulo_portugues: document.getElementById('titulo_portugues').value,
        titulo_original: { String: document.getElementById('titulo_original').value, Valid: document.getElementById('titulo_original').value !== '' },
        autor: { String: document.getElementById('autor').value, Valid: document.getElementById('autor').value !== '' },
        desenhista: { String: document.getElementById('desenhista').value, Valid: document.getElementById('desenhista').value !== '' },
        editora: { String: document.getElementById('editora').value, Valid: document.getElementById('editora').value !== '' },
        ano: { Int64: parseInt(document.getElementById('ano').value, 10) || 0, Valid: document.getElementById('ano').value !== '' },
        edicao: { String: document.getElementById('edicao').value, Valid: document.getElementById('edicao').value !== '' },
        isbn: { String: document.getElementById('isbn').value, Valid: document.getElementById('isbn').value !== '' },
        idioma: { String: document.getElementById('idioma').value, Valid: document.getElementById('idioma').value !== '' },
    };
    const method = id ? 'PUT' : 'POST';
    const url = id ? `${apiUrl}/${id}` : apiUrl;
    try {
        const response = await fetch(url, {
            method: method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(itemData),
        });
        if (!response.ok) throw new Error(`Falha ao salvar: ${response.statusText}`);
        showFormMessage('Item salvo com sucesso!');
        setTimeout(hideFormMessage, 4000);
        resetForm();
        fetchItems(id ? currentPage : 1);
    } catch (error) {
        console.error('Erro ao salvar:', error);
        showFormMessage(error.message, true);
    }
});

filterForm.addEventListener('submit', (e) => {
    e.preventDefault();
    currentFilters = new URLSearchParams();
    if (document.getElementById('filter-titulo_portugues').value) currentFilters.set('titulo_portugues', document.getElementById('filter-titulo_portugues').value);
    if (document.getElementById('filter-autor').value) currentFilters.set('autor', document.getElementById('filter-autor').value);
    if (document.getElementById('filter-ano').value) currentFilters.set('ano', document.getElementById('filter-ano').value);
    if (document.getElementById('filter-tipo').value) currentFilters.set('tipo', document.getElementById('filter-tipo').value);
    currentFilters.set('sortBy', document.getElementById('filter-sortby').value);
    fetchItems(1);
});

clearFiltersBtn.addEventListener('click', () => {
    filterForm.reset();
    currentFilters = new URLSearchParams();
    fetchItems(1);
});

document.addEventListener('DOMContentLoaded', () => {
    fetchItems(1);
    toggleDesenhistaField();
});
