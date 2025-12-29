package model;

public class RegiaoModel {
    private Integer idRegiao;
    private String nomeRegiao;

    public RegiaoModel() {
    }

    public RegiaoModel(Integer idRegiao, String nomeRegiao) {
        this.idRegiao = idRegiao;
        this.nomeRegiao = nomeRegiao;
    }

    public Integer getIdRegiao() {
        return idRegiao;
    }

    public void setIdRegiao(Integer idRegiao) {
        this.idRegiao = idRegiao;
    }

    public String getNomeRegiao() {
        return nomeRegiao;
    }

    public void setNomeRegiao(String nomeRegiao) {
        this.nomeRegiao = nomeRegiao;
    }

    @Override
    public String toString() {
        return "RegiaoModel{" +
                "idRegiao=" + idRegiao +
                ", nomeRegiao='" + nomeRegiao + '\'' +
                '}';
    }
}
