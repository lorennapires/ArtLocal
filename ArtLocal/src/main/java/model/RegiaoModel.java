package model;

public class RegiaoModel {
    private Integer idRegiao;
    private String nomeRegiao;
    private int totalArtistas;
    private int totalObras;

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

    public int getTotalArtistas() {
        return totalArtistas;
    }

    public void setTotalArtistas(int totalArtistas) {
        this.totalArtistas = totalArtistas;
    }

    public int getTotalObras() {
        return totalObras;
    }

    public void setTotalObras(int totalObras) {
        this.totalObras = totalObras;
    }

    @Override
    public String toString() {
        return "RegiaoModel{" +
                "idRegiao=" + idRegiao +
                ", nomeRegiao='" + nomeRegiao + '\'' +
                ", totalArtistas=" + totalArtistas +
                ", totalObras=" + totalObras +
                '}';
    }
}