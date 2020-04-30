package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Usuario
import ar.edu.unsam.proyecto.exceptions.UserDoesntExist
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable

@Observable
@Accessors
class RepositorioUsuario extends Repositorio<Usuario> {

	public static RepositorioUsuario repoUsuario

	static def RepositorioUsuario getInstance() {
		if (repoUsuario === null) {
			repoUsuario = new RepositorioUsuario()
		}
		repoUsuario
	}

	def reset() {
		repoUsuario = null
	}

	private new() {}
	
	int idAutoincremental = 1

	def createOrUpdate(Usuario usuario) {
		usuario.validar
		if (usuario.id !== null) {
			this.update(usuario)
		} else {
			this.asignarIdUsuario(usuario)
			this.create(usuario)
		}
	}
	
	def existeUsuarioConMail(String email){
		
		coleccion.exists[usuario | usuario.tieneEsteMail(email)]
		
	}

	def asignarIdUsuario(Usuario usuario) {
		usuario.id = 'U' + idAutoincremental.toString
		idAutoincremental++
	}

	def update(Usuario usuario) {
		
		//https://i.imgur.com/S6X48jx.png
		
		//searchById(superIndividuo.id).amigos = superIndividuo.amigos
		println("Tengo actualizar un usuario... no se como hacerlo")
	}

	def searchById(String cadenaId) {
		val usuario = coleccion.filter[usuario|usuario.id == cadenaId].head
		return (usuario !== null) ? usuario : throw new UserDoesntExist("No existe un usuario con ese ID")
	}
	
	def getUsuarioConCredenciales(String username, String password){
		coleccion.filter[usuario | usuario.tieneCredenciales(username, password)].head
	}

	
}