package modelo;

public class Paciente {
    private int id;
    private String nome;
    private String email;
    private String numeroUtente;

    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getNumeroUtente() { return numeroUtente; }
    public void setNumeroUtente(String numeroUtente) { this.numeroUtente = numeroUtente; }
}
