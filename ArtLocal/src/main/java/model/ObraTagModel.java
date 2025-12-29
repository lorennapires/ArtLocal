package model;

public class ObraTagModel {
    private Integer idObra;
    private Integer idTag;

    public ObraTagModel() {
    }

    public ObraTagModel(Integer idObra, Integer idTag) {
        this.idObra = idObra;
        this.idTag = idTag;
    }

    public Integer getIdObra() {
        return idObra;
    }

    public void setIdObra(Integer idObra) {
        this.idObra = idObra;
    }

    public Integer getIdTag() {
        return idTag;
    }

    public void setIdTag(Integer idTag) {
        this.idTag = idTag;
    }

    @Override
    public String toString() {
        return "ObraTagModel{" +
                "idObra=" + idObra +
                ", idTag=" + idTag +
                '}';
    }
}