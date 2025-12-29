package model;

import java.time.LocalDateTime;

public class UsuarioModel {
    private Integer idUsuario;
    private String nomeCompleto;
    private String nomeArtistico;
    private String idIcone;
    private String biografia;
    private String email;
    private String senha;
    private String tipoUsuario;
    private String portfolio;
    private Integer categoriaPrincipal;
    private String tagsPrincipais;
    private LocalDateTime dataCriacao;
    private Integer idRegiao;  

    public UsuarioModel() {
    }

    public UsuarioModel(Integer idUsuario, String nomeCompleto, String nomeArtistico, 
                        String idIcone, String biografia, String email, String senha, 
                        String tipoUsuario, String portfolio, Integer categoriaPrincipal, 
                        String tagsPrincipais, LocalDateTime dataCriacao, Integer idRegiao) {
        this.idUsuario = idUsuario;
        this.nomeCompleto = nomeCompleto;
        this.nomeArtistico = nomeArtistico;
        this.idIcone = idIcone;
        this.biografia = biografia;
        this.email = email;
        this.senha = senha;
        this.tipoUsuario = tipoUsuario;
        this.portfolio = portfolio;
        this.categoriaPrincipal = categoriaPrincipal;
        this.tagsPrincipais = tagsPrincipais;
        this.dataCriacao = dataCriacao;
        this.idRegiao = idRegiao;  
    }

    public Integer getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(Integer idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getNomeCompleto() {
        return nomeCompleto;
    }

    public void setNomeCompleto(String nomeCompleto) {
        this.nomeCompleto = nomeCompleto;
    }

    public String getNomeArtistico() {
        return nomeArtistico;
    }

    public void setNomeArtistico(String nomeArtistico) {
        this.nomeArtistico = nomeArtistico;
    }

    public String getIdIcone() {
        return idIcone;
    }

    public void setIdIcone(String idIcone) {
        this.idIcone = idIcone;
    }

    public String getBiografia() {
        return biografia;
    }

    public void setBiografia(String biografia) {
        this.biografia = biografia;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }

    public String getTipoUsuario() {
        return tipoUsuario;
    }

    public void setTipoUsuario(String tipoUsuario) {
        this.tipoUsuario = tipoUsuario;
    }

    public String getPortfolio() {
        return portfolio;
    }

    public void setPortfolio(String portfolio) {
        this.portfolio = portfolio;
    }

    public Integer getCategoriaPrincipal() {
        return categoriaPrincipal;
    }

    public void setCategoriaPrincipal(Integer categoriaPrincipal) {
        this.categoriaPrincipal = categoriaPrincipal;
    }

    public String getTagsPrincipais() {
        return tagsPrincipais;
    }

    public void setTagsPrincipais(String tagsPrincipais) {
        this.tagsPrincipais = tagsPrincipais;
    }

    public LocalDateTime getDataCriacao() {
        return dataCriacao;
    }

    public void setDataCriacao(LocalDateTime dataCriacao) {
        this.dataCriacao = dataCriacao;
    }

    public Integer getIdRegiao() {  
        return idRegiao;
    }

    public void setIdRegiao(Integer idRegiao) {  
        this.idRegiao = idRegiao;
    }

    @Override
    public String toString() {
        return "UsuarioModel{" +
                "idUsuario=" + idUsuario +
                ", nomeCompleto='" + nomeCompleto + '\'' +
                ", nomeArtistico='" + nomeArtistico + '\'' +
                ", idIcone='" + idIcone + '\'' +
                ", email='" + email + '\'' +
                ", tipoUsuario='" + tipoUsuario + '\'' +
                ", idRegiao=" + idRegiao +
                ", dataCriacao=" + dataCriacao +
                '}';
    }
}