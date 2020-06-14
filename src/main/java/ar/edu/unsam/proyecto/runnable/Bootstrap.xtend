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

	Usuario sebaCapo = new Usuario() => [
		nombre = "sebaCapo"
		password = dotenv.get("PASSWORD")
		sexo = "Masculino"
		posicion = "Delantero"
		foto = "https://i.imgur.com/1PkBT5g.jpg"
		email = dotenv.get("EMAIL_SEBA")
		lat = -34.5677486
		lon = -58.489429
	]

	Usuario nikoBostero = new Usuario() => [
		nombre = "nikoBostero"
		password = dotenv.get("PASSWORD")
		sexo = "Masculino"
		posicion = "Delantero"
		foto = "https://i.imgur.com/es7dPKd.jpg"
		email = dotenv.get("EMAIL_NIKO")
		lat = -34.6344499
		lon = -58.3672355
	]

	Usuario andy = new Usuario() => [
		nombre = "andy"
		password = dotenv.get("PASSWORD")
		sexo = "Masculino"
		posicion = "Defensor"
		foto = "https://i.imgur.com/ajsPlMV.jpg"
		email = dotenv.get("EMAIL_ANDY")
		lat = -34.5724894
		lon = -58.4766751
	]

	Usuario jugador1 = new Usuario() => [
		nombre = "Jugador 1"
		password = dotenv.get("PASSWORD")
		sexo = "Masculino"
		posicion = "Mediocampista"
		foto = "https://i.imgur.com/dNrx8Ts.jpg"
		email = "elmaildeljugador1@sarasa.com"
		lat = -34.6029831
		lon = -58.4408178
	]

	Usuario jugador2 = new Usuario() => [
		nombre = "Jugador 2"
		password = dotenv.get("PASSWORD")
		sexo = "Femenino"
		posicion = "Arquero"
		foto = "https://i.imgur.com/Q9bw6oP.jpg"
		email = "elmaildeljugador2@sarasa.com"
		lat = -34.5768884
		lon = -58.4904551
	]

	Usuario jugador3 = new Usuario() => [
		nombre = "Jugador 3"
		password = dotenv.get("PASSWORD")
		sexo = "Masculino"
		posicion = "Mediocampista"
		foto = "https://i.imgur.com/zS9GKGi.jpg"
		email = "elmaildeljugador3@sarasa.com"
		lat = -34.6029831
		lon = -58.4408178
	]

	Usuario jugador4 = new Usuario() => [
		nombre = "Jugador 4"
		password = dotenv.get("PASSWORD")
		sexo = "Femenino"
		posicion = "Arquero"
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

	Equipo equipazo = new Equipo() => [
		nombre = "El equipazo"
		owner = sebaCapo
		foto = "https://i.imgur.com/hccT1z9.jpg"
		integrantes = new HashSet(Arrays.asList(sebaCapo, nikoBostero, andy, jugador1, jugador2))
	]

	Equipo equipoMalo = new Equipo() => [
		nombre = "El equipo malo"
		owner = andy
		foto = "https://i.imgur.com/BoQriOI.jpg"
		integrantes = new HashSet(Arrays.asList(jugador1, jugador2, jugador3, jugador4, andy))
	]
	
	Equipo equipoCampeon = new Equipo() => [
		nombre = "Supercampeones"
		owner = andy
		foto = "https://i.imgur.com/M9N9o78.jpg"
		integrantes = new HashSet(Arrays.asList(pepe, juan, sofia, nikoBostero, andy))
	]

	Equipo equipoIncompleto = new Equipo() => [
		nombre = "Equipo incompleto"
		owner = nikoBostero
		foto = "https://i.imgur.com/1gg90fn.jpg"
		integrantes = new HashSet(Arrays.asList(sebaCapo, nikoBostero, andy))
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
		lat = -34.5748777
		lon = -58.4903939
		canchas = new HashSet(Arrays.asList(urquiza1, urquiza2))
		nombreDuenio = "Tito Bara"
		email = "futbolUrquiza@gmail.com"
		direccion = "Roosevelt 5110"
		foto = "https://i.imgur.com/uBq4qBV.jpg"
	]

	Empresa empresaVicenteLopez = new Empresa => [
		nombre = "Futbol Mitre"
		lat = -34.5141931
		lon = -58.5315329
		canchas = new HashSet(Arrays.asList(vicLop1, vicLop2, vicLop3))
		nombreDuenio = "Jorge"
		email = "miraSiVaATenerMail@dePedoTieneAgua.com"
		direccion = "Mitre 3847"
		foto = "https://i.imgur.com/9QfoGNr.png"
	]

	Empresa empresaArgentinos = new Empresa => [
		nombre = "Argentinos :)"
		lat = -34.6078057
		lon = -58.4763221
		canchas = new HashSet(Arrays.asList(argen1, argen2))
		nombreDuenio = "Esteban"
		email = "esteban@cancha.com"
		direccion = "Sarasa 123"
		foto = "https://i.imgur.com/RUOAmuX.png"
	]

	Partido partido1 = new Partido() => [
		equipo1 = equipazo
		equipo2 = equipoMalo
		empresa = empresaUrquiza
		canchaReservada = urquiza1
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 12, 25), LocalTime.of(20, 00))
	]

	Partido partido2 = new Partido() => [
		equipo1 = equipazo
		equipo2 = equipoIncompleto
		empresa = empresaVicenteLopez
		canchaReservada = vicLop2
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 4, 24), LocalTime.of(17, 00))
	]

	Partido partido3 = new Partido() => [
		equipo1 = equipazo
		equipo2 = equipoIncompleto
		empresa = empresaArgentinos
		canchaReservada = argen1
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 12, 5), LocalTime.of(23, 00))
	]

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
		repoUsuarios.crearUsuario(jugador1)
		repoUsuarios.crearUsuario(jugador2)
		repoUsuarios.crearUsuario(jugador3)
		repoUsuarios.crearUsuario(jugador4)
		repoUsuarios.crearUsuario(pepe)
		repoUsuarios.crearUsuario(sofia)
		repoUsuarios.crearUsuario(agustin)
		repoUsuarios.crearUsuario(juan)

		repoEquipo.create(equipazo)
		repoEquipo.create(equipoMalo)
		repoEquipo.create(equipoIncompleto)
		repoEquipo.create(equipoCampeon)

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

		repoPartido.crearPartido(partido1)
		repoPartido.crearPartido(partido2)
		repoPartido.crearPartido(partido3)

		// TODO: Pensar si podes evitar mandar un update
		//andy.crearAmistad(sebaCapo)
		andy.crearAmistad(nikoBostero)
		andy.crearAmistad(jugador1)
		andy.crearAmistad(jugador2)
		andy.crearAmistad(jugador4)
		andy.crearAmistad(pepe)
		andy.crearAmistad(sofia)


		nikoBostero.crearAmistad(sebaCapo)
		nikoBostero.crearAmistad(jugador1)
		nikoBostero.crearAmistad(jugador2)
		nikoBostero.crearAmistad(jugador3)
		nikoBostero.crearAmistad(juan)
		nikoBostero.crearAmistad(pepe)

		sebaCapo.crearAmistad(jugador1)
		sebaCapo.crearAmistad(jugador2)
		sebaCapo.crearAmistad(jugador4)
		sebaCapo.crearAmistad(juan)
		sebaCapo.crearAmistad(sofia)

		repoUsuarios.update(sebaCapo)
		repoUsuarios.update(nikoBostero)
		repoUsuarios.update(andy)
		repoUsuarios.update(jugador1)
		repoUsuarios.update(jugador2)
		repoUsuarios.update(jugador3)
		repoUsuarios.update(jugador4)
		repoUsuarios.update(pepe)
		repoUsuarios.update(sofia)
		repoUsuarios.update(agustin)
		repoUsuarios.update(juan)

	}

}
