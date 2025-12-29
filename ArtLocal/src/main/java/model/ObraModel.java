package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class ObraModel {
    private Integer idObra;
    private Integer idUsuario;
    private Integer idCategoria;
    private String nomeObra;
    private String descricao;
    private String linkExterno;
    private BigDecimal preco;
    private LocalDateTime dataCriacao;

    public ObraModel() {
    }

    public ObraModel(Integer idObra, Integer idUsuario, Integer idCategoria, 
                     String nomeObra, String descricao, String linkExterno, 
                     BigDecimal preco, LocalDateTime dataCriacao) {
        this.idObra = idObra;
        this.idUsuario = idUsuario;
        this.idCategoria = idCategoria;
        this.nomeObra = nomeObra;
        this.descricao = descricao;
        this.linkExterno = linkExterno;
        this.preco = preco;
        this.dataCriacao = dataCriacao;
    }

    public Integer getIdObra() {
        return idObra;
    }

    public void setIdObra(Integer idObra) {
        this.idObra = idObra;
    }

    public Integer getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(Integer idUsuario) {
        this.idUsuario = idUsuario;
    }

    public Integer getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(Integer idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getNomeObra() {
        return nomeObra;
    }

    public void setNomeObra(String nomeObra) {
        this.nomeObra = nomeObra;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getLinkExterno() {
        return linkExterno;
    }

    public void setLinkExterno(String linkExterno) {
        this.linkExterno = linkExterno;
    }

    public BigDecimal getPreco() {
        return preco;
    }

    public void setPreco(BigDecimal preco) {
        this.preco = preco;
    }

    public LocalDateTime getDataCriacao() {
        return dataCriacao;
    }

    public void setDataCriacao(LocalDateTime dataCriacao) {
        this.dataCriacao = dataCriacao;
    }

    @Override
    public String toString() {
        return "ObraModel{" +
                "idObra=" + idObra +
                ", idUsuario=" + idUsuario +
                ", idCategoria=" + idCategoria +
                ", nomeObra='" + nomeObra + '\'' +
                ", preco=" + preco +
                ", dataCriacao=" + dataCriacao +
                '}';
    }
}