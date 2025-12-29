package model;

public class TagModel {
    private Integer idTag;
    private String nomeTag;

    public TagModel() {
    }

    public TagModel(Integer idTag, String nomeTag) {
        this.idTag = idTag;
        this.nomeTag = nomeTag;
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

    @Override
    public String toString() {
        return "TagModel{" +
                "idTag=" + idTag +
                ", nomeTag='" + nomeTag + '\'' +
                '}';
    }
}