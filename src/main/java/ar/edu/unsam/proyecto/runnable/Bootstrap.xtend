package ar.edu.unsam.proyecto.runnable

import ar.edu.unsam.proyecto.domain.Cancha
import ar.edu.unsam.proyecto.domain.Empresa
import ar.edu.unsam.proyecto.domain.Equipo
import ar.edu.unsam.proyecto.domain.Partido
import ar.edu.unsam.proyecto.domain.Promocion
import ar.edu.unsam.proyecto.domain.Usuario
import ar.edu.unsam.proyecto.repos.RepositorioCancha
import ar.edu.unsam.proyecto.repos.RepositorioEmpresa
import ar.edu.unsam.proyecto.repos.RepositorioEquipo
import ar.edu.unsam.proyecto.repos.RepositorioPartido
import ar.edu.unsam.proyecto.repos.RepositorioPromocion
import ar.edu.unsam.proyecto.repos.RepositorioUsuario
import ar.edu.unsam.proyecto.webApi.RestHost
import io.github.cdimascio.dotenv.Dotenv
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import java.util.Arrays
import java.util.HashSet

class Bootstrap {

	public static Bootstrap bootstrap

	static def Bootstrap getInstance() {
		if (bootstrap === null) {
			bootstrap = new Bootstrap()
		}
		bootstrap
	}

	Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load()

	private new() {
	}

	RepositorioUsuario repoUsuarios = RepositorioUsuario.instance
	RepositorioPartido repoPartido = RepositorioPartido.instance
	RepositorioEquipo repoEquipo = RepositorioEquipo.instance
	RepositorioEmpresa repoEmpresa = RepositorioEmpresa.instance
	RepositorioCancha repoCancha = RepositorioCancha.instance
	RepositorioPromocion repoPromocion = RepositorioPromocion.instance
	RestHost restHost = new RestHost

	Usuario sebaCapo = new Usuario() => [
		nombre = "Seba"
		password = dotenv.get("PASSWORD")
		sexo = "Masculino"
		posicion = "Delantero"
		foto = "https://i.imgur.com/1PkBT5g.jpg"
		email = dotenv.get("EMAIL_SEBA")
		lat = -34.5677486
		lon = -58.489429
	]

	Usuario nikoBostero = new Usuario() => [
		nombre = "Nico"
		password = dotenv.get("PASSWORD")
		sexo = "Masculino"
		posicion = "Delantero"
		foto = "https://i.imgur.com/es7dPKd.jpg"
		email = dotenv.get("EMAIL_NIKO")
		lat = -34.6344499
		lon = -58.3672355
	]

	Usuario andy = new Usuario() => [
		nombre = "Andy"
		password = dotenv.get("PASSWORD")
		sexo = "Masculino"
		posicion = "Defensor"
		foto = "https://i.imgur.com/ajsPlMV.jpg"
		email = dotenv.get("EMAIL_ANDY")
		lat = -34.5724894
		lon = -58.4766751
	]

	Usuario federico = new Usuario() => [
		nombre = "Federico"
		password = dotenv.get("PASSWORD")
		sexo = "Masculino"
		posicion = "Mediocampista"
		foto = "https://i.imgur.com/859oo3P.jpg"
		email = "federico@gmail.com"
		lat = -34.6029831
		lon = -58.4408178
	]

	Usuario carla = new Usuario() => [
		nombre = "Carla"
		password = dotenv.get("PASSWORD")
		sexo = "Femenino"
		posicion = "Arquero"
		foto = "https://i.imgur.com/CZv1viz.jpg"
		email = "carla@gmail.com"
		lat = -34.4768884
		lon = -58.5904551
	]

	Usuario marcela = new Usuario() => [
		nombre = "Marcela"
		password = dotenv.get("PASSWORD")
		sexo = "Femenino"
		posicion = "Delantero"
		foto = "https://i.imgur.com/BGDdGM1.jpg"
		email = "marcela@gmail.com"
		lat = -34.5653851
		lon = -58.4986315
	]
	
	Usuario julieta = new Usuario() => [
		nombre = "Julieta"
		password = dotenv.get("PASSWORD")
		sexo = "Femenino"
		posicion = "Defensor"
		foto = "https://i.imgur.com/ChhMW1K.jpg"
		email = "juli@gmail.com"
		lat = -34.8768884
		lon = -58.6404551
		
	]
	
	Usuario carlos = new Usuario() => [
		nombre = "Carlos"
		password = dotenv.get("PASSWORD")
		sexo = "Masculino"
		posicion = "Delantero"
		foto = "https://i.imgur.com/inqY03S.jpg"
		email = "carlos@gmail.com"
		lat = -34.6029831
		lon = -58.4408178
	]

	Usuario florencia = new Usuario() => [
		nombre = "Florencia"
		password = dotenv.get("PASSWORD")
		sexo = "Femenino"
		posicion = "Mediocampista"
		foto = "https://i.imgur.com/vtmHBNo.jpg"
		email = "elmaildeljugador4@sarasa.com"
		lat = -34.5768884
		lon = -58.4904551
	]

	Usuario pepe = new Usuario() => [
		nombre = "Pepe"
		password = dotenv.get("PASSWORD")
		sexo = "Masculino"
		posicion = "Defensor"
		foto = "https://i.imgur.com/oXy8RKG.jpg"
		email = "pepe@gmail.com"
		lat = -34.6016244
		lon = -58.4420183
	]

	Usuario sofia = new Usuario() => [
		nombre = "Sofia"
		password = dotenv.get("PASSWORD")
		sexo = "Femenino"
		posicion = "Delantero"
		foto = "https://i.imgur.com/C5hUv7k.jpg"
		email = "sofia@gmail.com"
		lat = -34.6016244
		lon = -58.4420183
	]

	Usuario agustin = new Usuario() => [
		nombre = "Agustin"
		password = dotenv.get("PASSWORD")
		sexo = "Masculino"
		posicion = "Mediocampista"
		foto = "https://i.imgur.com/9qkIMhI.jpg"
		email = "agustin@gmail.com"
		lat = -34.6016244
		lon = -58.4420183
	]

	Usuario juan = new Usuario() => [
		nombre = "Juancete"
		password = dotenv.get("PASSWORD")
		sexo = "Masculino"
		posicion = "Delantero"
		foto = "https://i.imgur.com/NPD1nqC.jpg"
		email = "juancete@gmail.com"
		lat = -34.6016244
		lon = -58.4420183
	]
	
	Usuario lucas = new Usuario() => [
		nombre = "Lucas"
		password = dotenv.get("PASSWORD")
		sexo = "Masculino"
		posicion = "Mediocampista"
		foto = "https://i.imgur.com/qfRIvml.jpg"
		email = "lucas@gmail.com"
		lat = -34.8016244
		lon = -58.3220183
	]
	
	Usuario micaela = new Usuario() => [
		nombre = "Micaela"
		password = dotenv.get("PASSWORD")
		sexo = "Femenino"
		posicion = "Defensor"
		foto = "https://i.imgur.com/uACXHMk.jpg"
		email = "micaela@gmail.com"
		lat = -34.5416244
		lon = -58.4521183
	]
	

	Equipo borbotones = new Equipo() => [
		nombre = "Los borbotones"
		owner = sebaCapo
		foto = "https://i.imgur.com/ixBuxSY.jpg"
		integrantes = new HashSet(Arrays.asList(sebaCapo, nikoBostero, andy, federico, carla))
	]

	Equipo dreamTeam = new Equipo() => [
		nombre = "El Dream Team"
		owner = andy
		foto = "https://i.imgur.com/BoQriOI.jpg"
		integrantes = new HashSet(Arrays.asList(federico, carla, carlos, florencia, andy))
	]
	
	Equipo supercampeones = new Equipo() => [
		nombre = "Supercampeones"
		owner = andy
		foto = "https://i.imgur.com/M9N9o78.jpg"
		integrantes = new HashSet(Arrays.asList(pepe, juan, sofia, nikoBostero, andy))
	]

	Equipo indecisos = new Equipo() => [
		nombre = "Los indecisos"
		owner = sebaCapo
		foto = "https://i.imgur.com/2KpShyB.jpg"
		integrantes = new HashSet(Arrays.asList(lucas, sebaCapo, nikoBostero, carlos))
	]
	
	Equipo looneyTeam = new Equipo() =>[
		nombre = "Looney Team"
		owner = andy
		foto = "https://i.pinimg.com/originals/6b/5d/98/6b5d98fc87a2874e6cb8526eb05ea03a.jpg"
		integrantes = new HashSet(Arrays.asList(federico, florencia, lucas, marcela, julieta))
	]
	
	Equipo hayEquipo = new Equipo() =>[
		nombre = "Hay Equipo"
		owner = sebaCapo
		foto = "https://i.imgur.com/KBA4jOL.jpg"
		integrantes = new HashSet(Arrays.asList(sofia, julieta, carla, florencia))
	]

	Cancha urquiza1 = new Cancha() => [
		foto = "https://i.imgur.com/jrziFQc.png"
		setSuperficie = "sintetico"
		cantidadJugadores = 10
		precio = 2000.0
	]

	Cancha urquiza2 = new Cancha() => [
		foto = "https://i.imgur.com/iUBWJAL.jpg"
		setSuperficie = "sintetico"
		cantidadJugadores = 10
		precio = 2000.0
	]

	Cancha vicLop1 = new Cancha() => [
		foto = "https://i.imgur.com/J29IXSA.png"
		setSuperficie = "sintetico"
		cantidadJugadores = 10
		precio = 1500.0
	]

	Cancha vicLop2 = new Cancha() => [
		foto = "https://i.imgur.com/OO24aMM.jpg"
		setSuperficie = "sintetico"
		cantidadJugadores = 10
		precio = 1500.0
	]

	Cancha vicLop3 = new Cancha() => [
		foto = "https://i.imgur.com/k14oJiW.jpg"
		setSuperficie = "cemento"
		cantidadJugadores = 14
		precio = 2100.0
	]

	Cancha argen1 = new Cancha() => [
		foto = "https://i.imgur.com/1eIVVny.jpg"
		setSuperficie = "sintetico"
		cantidadJugadores = 8
		precio = 1800.0
	]

	Cancha argen2 = new Cancha() => [
		foto = "https://i.imgur.com/2yZN1T5.jpg"
		setSuperficie = "sintetico"
		cantidadJugadores = 12
		precio = 2500.0
	]

	Empresa empresaUrquiza = new Empresa => [
		nombre = "Futbol Urquiza"
		canchas = new HashSet(Arrays.asList(urquiza1, urquiza2))
		nombreDuenio = "Tito Bara"
		email = "futbolUrquiza@gmail.com"
		direccion = "Roosevelt 5110"
		foto = "https://i.imgur.com/uBq4qBV.jpg"
	]

	Empresa empresaVicenteLopez = new Empresa => [
		nombre = "Futbol Mitre"
		canchas = new HashSet(Arrays.asList(vicLop1, vicLop2, vicLop3))
		nombreDuenio = "Jorge"
		email = "miraSiVaATenerMail@dePedoTieneAgua.com"
		direccion = "Mitre 3847"
		foto = "https://i.imgur.com/9QfoGNr.png"
	]

	Empresa empresaArgentinos = new Empresa => [
		nombre = "Argentinos Futboller"
		canchas = new HashSet(Arrays.asList(argen1, argen2))
		nombreDuenio = "Esteban"
		email = "esteban@cancha.com"
		direccion = "Av. Chorroarin 670"
		foto = "https://i.imgur.com/RUOAmuX.png"
	]

 Partido partidoBienFormado = new Partido() => [
		equipo1 = supercampeones
		equipo2 = looneyTeam
		empresa = empresaUrquiza
		canchaReservada = urquiza1
		//fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 12, 25), LocalTime.of(20, 00))
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 7, 6), LocalTime.of(20, 00))
	]

/*
	Partido partido1 = new Partido() => [
		equipo1 = borbotones
		equipo2 = dreamTeam
		empresa = empresaUrquiza
		canchaReservada = urquiza1
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 12, 25), LocalTime.of(20, 00))
	]
	
  
	Partido partido2 = new Partido() => [
		equipo1 = borbotones
		equipo2 = indecisos
		empresa = empresaVicenteLopez
		canchaReservada = vicLop2
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 4, 24), LocalTime.of(17, 00))
	]

	Partido partido3 = new Partido() => [
		equipo1 = borbotones
		equipo2 = indecisos
		empresa = empresaArgentinos
		canchaReservada = argen1
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 12, 5), LocalTime.of(23, 00))
	]
*/
	Promocion promo1 = new Promocion() => [
		codigo = "cocacola"
		descripcion = "Con Coca-Cola te hacemos el aguante!"
		porcentajeDescuento = 25
	]

	Promocion promo2 = new Promocion() => [
		codigo = "asd"
		descripcion = "Esta promo es una prueba"
		porcentajeDescuento = 50
	]

	Promocion promo3 = new Promocion() => [
		codigo = "nike"
		descripcion = "Just Do It"
		porcentajeDescuento = 15
	]

	def runBootstrap() {

		repoUsuarios.crearUsuario(sebaCapo)
		repoUsuarios.crearUsuario(nikoBostero)
		repoUsuarios.crearUsuario(andy)
		repoUsuarios.crearUsuario(federico)
		repoUsuarios.crearUsuario(carla)
		repoUsuarios.crearUsuario(carlos)
		repoUsuarios.crearUsuario(florencia)
		repoUsuarios.crearUsuario(pepe)
		repoUsuarios.crearUsuario(sofia)
		repoUsuarios.crearUsuario(agustin)
		repoUsuarios.crearUsuario(juan)
		repoUsuarios.crearUsuario(marcela)
		repoUsuarios.crearUsuario(julieta)
		repoUsuarios.crearUsuario(lucas)
		repoUsuarios.crearUsuario(micaela)

		repoEquipo.create(borbotones)
		repoEquipo.create(dreamTeam)
		repoEquipo.create(indecisos)
		repoEquipo.create(supercampeones)
		repoEquipo.create(looneyTeam)
		repoEquipo.create(hayEquipo)

		repoCancha.create(urquiza1)
		repoCancha.create(urquiza2)
		repoCancha.create(vicLop1)
		repoCancha.create(vicLop2)
		repoCancha.create(vicLop3)
		repoCancha.create(argen1)
		repoCancha.create(argen2)

		repoEmpresa.create(empresaUrquiza)
		repoEmpresa.create(empresaVicenteLopez)
		repoEmpresa.create(empresaArgentinos)

		repoPromocion.create(promo1)
		repoPromocion.create(promo2)
		repoPromocion.create(promo3)

		// TODO: Pensar si podes evitar mandar un update
		andy.crearAmistad(sebaCapo)
		andy.crearAmistad(federico)
		andy.crearAmistad(carla)
		andy.crearAmistad(carlos)
		andy.crearAmistad(florencia)
		andy.crearAmistad(pepe)
		andy.crearAmistad(juan)
		//andy.crearAmistad(sofia)
		andy.crearAmistad(nikoBostero)
		andy.crearAmistad(lucas)
		andy.crearAmistad(marcela)
		andy.crearAmistad(julieta)

		nikoBostero.crearAmistad(sebaCapo)
		nikoBostero.crearAmistad(federico)
		nikoBostero.crearAmistad(carla)

		sebaCapo.crearAmistad(lucas)
		sebaCapo.crearAmistad(nikoBostero)
		sebaCapo.crearAmistad(carlos)
		sebaCapo.crearAmistad(sofia)
		sebaCapo.crearAmistad(julieta)
		sebaCapo.crearAmistad(florencia)

		repoUsuarios.update(sebaCapo)
		repoUsuarios.update(nikoBostero)
		repoUsuarios.update(andy)
		repoUsuarios.update(federico)
		repoUsuarios.update(carla)
		repoUsuarios.update(carlos)
		repoUsuarios.update(florencia)
		repoUsuarios.update(pepe)
		repoUsuarios.update(sofia)
		repoUsuarios.update(agustin)
		repoUsuarios.update(juan)
		repoUsuarios.update(marcela)
		repoUsuarios.update(julieta)
		repoUsuarios.update(lucas)
		repoUsuarios.update(micaela)


		restHost.crearNuevoPartido(partidoBienFormado)
		//restHost.crearNuevoPartido(partido1)

	}

}
