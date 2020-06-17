package ar.edu.unsam.proyecto.webApi

import ar.edu.unsam.proyecto.runnable.Bootstrap
import io.github.cdimascio.dotenv.Dotenv
import org.uqbar.xtrest.api.XTRest

class WebApp {

	def static void main(String[] args) {
		var int port 
		var Dotenv dotenv
	
		dotenv = Dotenv.configure().ignoreIfMissing().load()
		
		try {
			port = Integer.parseInt(dotenv.get("PORT"))
		} catch (NumberFormatException e) {
			println("Probablemente te falta el archivo .env!!")
			throw e
		}
		
		val Bootstrap bootstrap = Bootstrap.getInstance()
		bootstrap.runBootstrap()
		val restHost = new RestHost

		XTRest.startInstance(port, new RestHostAPI(restHost))
	}

}
