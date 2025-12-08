package Model;

import java.time.LocalDateTime;

public class InteracaoModel {

    private Integer idInteracao;
    private Integer idUsuario;
    private Integer idObra;
    private Integer idUsuarioSeguido;
    private String tipo;
    private LocalDateTime dataInteracao;

    public Integer getIdInteracao() {
        return idInteracao;
    }

    public void setIdInteracao(Integer idInteracao) {
        this.idInteracao = idInteracao;
    }

    public Integer getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(Integer idUsuario) {
        this.idUsuario = idUsuario;
    }

    public Integer getIdObra() {
        return idObra;
    }

    public void setIdObra(Integer idObra) {
        this.idObra = idObra;
    }

    public Integer getIdUsuarioSeguido() {
        return idUsuarioSeguido;
    }

    public void setIdUsuarioSeguido(Integer idUsuarioSeguido) {
        this.idUsuarioSeguido = idUsuarioSeguido;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public LocalDateTime getDataInteracao() {
        return dataInteracao;
    }

    public void setDataInteracao(LocalDateTime dataInteracao) {
        this.dataInteracao = dataInteracao;
    }
}
