package ar.edu.unsam.proyecto.webApi

import ar.edu.unsam.proyecto.domain.Usuario
import ar.edu.unsam.proyecto.exceptions.IncorrectCredentials
import ar.edu.unsam.proyecto.repos.RepositorioUsuario
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RestHost {
	RepositorioUsuario repoUsuario = RepositorioUsuario.instance

	/*RepositorioEquipo repoEquipo
	 * RepositorioSuperIndividuo repoIndividuo
	 * RepositorioItem repoItem
	 RepositorioAmenaza repoAmenaza*/
	def getPeticionDePrueba() {
		return '{ "message": "La API Rest esta funcionando!! :)" }'
	}

	def loguearUsuario(String email, String password) {
		val usuario = repoUsuario.getUsuarioConCredenciales(email, password)
		usuario === null ? throw new IncorrectCredentials("Credenciales Invalidas") : return usuario
	}

	def signUpUsuario(Usuario usuario) {

		if (!repoUsuario.existeUsuarioConMail(usuario.email)){
			
				repoUsuario.create(usuario)
		} else {
			
				throw new IncorrectCredentials("Este mail ya pertenece a un usuario")
		}

	}

}
