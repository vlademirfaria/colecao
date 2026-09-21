package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestSetJSONHeader(t *testing.T) {
	recorder := httptest.NewRecorder()
	setJSONHeader(recorder)

	if got, want := recorder.Header().Get("Content-Type"), "application/json; charset=utf-8"; got != want {
		t.Fatalf("Content-Type = %q; want %q", got, want)
	}
}

func TestItemsHandlerOptions(t *testing.T) {
	req := httptest.NewRequest(http.MethodOptions, "/api/items", nil)
	recorder := httptest.NewRecorder()

	itemsHandler(recorder, req)

	if recorder.Code != http.StatusOK {
		t.Fatalf("status = %d; want %d", recorder.Code, http.StatusOK)
	}
}

func TestItemsHandlerMethodNotAllowed(t *testing.T) {
	req := httptest.NewRequest(http.MethodPatch, "/api/items", nil)
	recorder := httptest.NewRecorder()

	itemsHandler(recorder, req)

	if recorder.Code != http.StatusMethodNotAllowed {
		t.Fatalf("status = %d; want %d", recorder.Code, http.StatusMethodNotAllowed)
	}
}

func TestItemHandlerInvalidID(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/api/items/abc", nil)
	recorder := httptest.NewRecorder()

	itemHandler(recorder, req)

	if recorder.Code != http.StatusBadRequest {
		t.Fatalf("status = %d; want %d", recorder.Code, http.StatusBadRequest)
	}
}

func TestItemHandlerOptions(t *testing.T) {
	req := httptest.NewRequest(http.MethodOptions, "/api/items/1", nil)
	recorder := httptest.NewRecorder()

	itemHandler(recorder, req)

	if recorder.Code != http.StatusOK {
		t.Fatalf("status = %d; want %d", recorder.Code, http.StatusOK)
	}
}
