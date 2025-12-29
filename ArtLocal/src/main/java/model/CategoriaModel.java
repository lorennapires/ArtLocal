package model;

public class CategoriaModel {
    private Integer idCategoria;
    private String nomeCategoria;
    private String descricao;

    public CategoriaModel() {
    }

    public CategoriaModel(Integer idCategoria, String nomeCategoria, String descricao) {
        this.idCategoria = idCategoria;
        this.nomeCategoria = nomeCategoria;
        this.descricao = descricao;
    }

    public Integer getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(Integer idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getNomeCategoria() {
        return nomeCategoria;
    }

    public void setNomeCategoria(String nomeCategoria) {
        this.nomeCategoria = nomeCategoria;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    @Override
    public String toString() {
        return "CategoriaModel{" +
                "idCategoria=" + idCategoria +
                ", nomeCategoria='" + nomeCategoria + '\'' +
                ", descricao='" + descricao + '\'' +
                '}';
    }
}