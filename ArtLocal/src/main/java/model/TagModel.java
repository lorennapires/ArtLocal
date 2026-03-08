package model;

public class TagModel {
    private Integer idTag;
    private String nomeTag;
    private Integer idCategoria;

    public TagModel() {
    }

    public TagModel(Integer idTag, String nomeTag, Integer idCategoria) {
        this.idTag = idTag;
        this.nomeTag = nomeTag;
        this.idCategoria = idCategoria;
    }

    public Integer getIdTag() {
        return idTag;
    }

    public void setIdTag(Integer idTag) {
        this.idTag = idTag;
    }

    public String getNomeTag() {
        return nomeTag;
    }

    public void setNomeTag(String nomeTag) {
        this.nomeTag = nomeTag;
    }

    public Integer getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(Integer idCategoria) {
        this.idCategoria = idCategoria;
    }

    @Override
    public String toString() {
        return "TagModel{" +
                "idTag=" + idTag +
                ", nomeTag='" + nomeTag + '\'' +
                ", idCategoria=" + idCategoria +
                '}';
    }
}