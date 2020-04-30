package ar.edu.unsam.proyecto.runnable

import ar.edu.unsam.proyecto.domain.Cancha
import ar.edu.unsam.proyecto.domain.Empresa
import ar.edu.unsam.proyecto.domain.Equipo
import ar.edu.unsam.proyecto.domain.Partido
import ar.edu.unsam.proyecto.domain.Usuario
import ar.edu.unsam.proyecto.repos.RepositorioEquipo
import ar.edu.unsam.proyecto.repos.RepositorioPartido
import ar.edu.unsam.proyecto.repos.RepositorioUsuario
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime

class Bootstrap {

	public static Bootstrap bootstrap

	static def Bootstrap getInstance() {
		if (bootstrap === null) {
			bootstrap = new Bootstrap()
		}
		bootstrap
	}

	private new() {
	}

	RepositorioUsuario repoUsuarios = RepositorioUsuario.instance
	RepositorioPartido repoPartido = RepositorioPartido.instance
	RepositorioEquipo repoEquipo = RepositorioEquipo.instance

	Usuario sebaCapo = new Usuario() => [
		id = "U1"
		nombre = "sebaCapo"
		password = "mandarina"
		sexo = "M"
		posicion = "DC"
		foto = "https://i.imgur.com/gF6Q26G.jpg"
		email = "sebassdevita@gmail.com"
		lat = -34.5677486
		lon = -58.489429
	]

	Usuario nikoBostero = new Usuario() => [
		id = "U2"
		nombre = "nikoBostero"
		password = "mandarina"
		sexo = "M"
		posicion = "ED"
		foto = "https://i.imgur.com/a0UL9YQ.png"
		email = "niko.bostero.232@gmail.com"
		lat = -34.6344499
		lon = -58.3672355
	]

	Usuario andy = new Usuario() => [
		id = "U3"
		nombre = "andy"
		password = "mandarina"
		sexo = "M"
		posicion = "DFI"
		foto = "https://i.imgur.com/tBUGRSa.jpg"
		email = "andres27059934@gmail.com"
		lat = -34.6016244
		lon = -58.4420183
	]

	Usuario jugador1 = new Usuario() => [
		id = "U4"
		nombre = "Jugador 1"
		password = "mandarina"
		sexo = "M"
		posicion = "MC"
		foto = "https://i.imgur.com/DyYpkmS.jpg"
		email = "elmaildelnabo1@sarasa.com"
		lat = -34.6029831
		lon = -58.4408178
	]

	Usuario jugador2 = new Usuario() => [
		id = "U5"
		nombre = "Jugador 2"
		password = "mandarina"
		sexo = "F"
		posicion = "EI"
		foto = "https://i.imgur.com/AofDmoH.jpg"
		email = "elmaildelnabo2@sarasa.com"
		lat = -34.5768884
		lon = -58.4904551
	]

	Usuario jugador3 = new Usuario() => [
		id = "U6"
		nombre = "Jugador 3"
		password = "mandarina"
		sexo = "M"
		posicion = "MC"
		foto = "https://i.imgur.com/mUPUwOS.jpg"
		email = "elmaildelnabo3@sarasa.com"
		lat = -34.6029831
		lon = -58.4408178
	]

	Usuario jugador4 = new Usuario() => [
		id = "U7"
		nombre = "Jugador 4"
		password = "mandarina"
		sexo = "F"
		posicion = "EI"
		foto = "https://i.imgur.com/kzeiAar.jpg"
		email = "elmaildelnabo4@sarasa.com"
		lat = -34.5768884
		lon = -58.4904551
	]

	Equipo equipazo = new Equipo() => [
		id = "E1"
		nombre = "El equipazo"
		owner = sebaCapo
		foto = "https://i.imgur.com/hccT1z9.jpg"
		integrantes = #[sebaCapo, nikoBostero, andy, jugador1, jugador2]
	]

	Equipo equipoMalo = new Equipo() => [
		id = "E2"
		nombre = "El equipo malo"
		owner = andy
		foto = "https://i.imgur.com/RhqYpUg.jpg"
		integrantes = #[jugador1, jugador2, jugador3, jugador4, andy]
	]

	Equipo equipoIncompleto = new Equipo() => [
		id = "E3"
		nombre = "Equipo incompleto"
		owner = nikoBostero
		foto="https://i.imgur.com/lvR3nt3.jpg"
		integrantes = #[sebaCapo, nikoBostero, andy]
	]

	Cancha urquiza1 = new Cancha() => [
		id = "C1"
		nombre = "Cancha 1 Urquiza"
		cesped = "sintetico"
		cantidadJugadores = 10
	]

	Cancha urquiza2 = new Cancha() => [
		id = "C2"
		nombre = "Cancha 2 Urquiza"
		cesped = "sintetico"
		cantidadJugadores = 10
	]

	Cancha vicLop1 = new Cancha() => [
		id = "C3"
		nombre = "Cancha chica 1 Vic Lop"
		cesped = "sintetico"
		cantidadJugadores = 10
	]

	Cancha vicLop2 = new Cancha() => [
		id = "C4"
		nombre = "Cancha chica 2 Vic Lop"
		cesped = "sintetico"
		cantidadJugadores = 10
	]

	Cancha vicLop3 = new Cancha() => [
		id = "C5"
		nombre = "Cancha grande Vic Lop"
		cesped = "cemento"
		cantidadJugadores = 14
	]

	Cancha argen1 = new Cancha() => [
		id = "C6"
		nombre = "Cancha Chica Argentinos"
		cesped = "cemento"
		cantidadJugadores = 8
	]

	Cancha argen2 = new Cancha() => [
		id = "C7"
		nombre = "Cancha Grande Argentinos"
		cesped = "cemento"
		cantidadJugadores = 12
	]

	Empresa empresaUrquiza = new Empresa => [
		id = "E1"
		nombre = "Aguante uqz"
		lat = -34.5748777
		lon = -58.4903939
		canchas = #[urquiza1, urquiza2]
		nombreDuenio = "Tito Bara"
		email = "aguanteUqz@vieja.com"
		direccion = "Roosevelt 5110"
		foto = "https://lh5.googleusercontent.com/p/AF1QipPF3MOS4J-Ou0mvOreYT8l3sIfHQu8_i1pQFbqI=w408-h509-k-no"
	]

	Empresa empresaVicenteLopez = new Empresa => [
		id = "E2"
		nombre = "Queda en la loma del orto"
		lat = -34.5141931
		lon = -58.5315329
		canchas = #[vicLop1, vicLop2, vicLop3]
		nombreDuenio = "Jorge"
		email = "miraSiVaATenerMail@dePedoTieneAgua.com"
		direccion = "Mitre 3847"
		foto = "https://i.imgur.com/0R5wqI5.jpg"
	]

	Empresa empresaArgentinos = new Empresa => [
		id = "E3"
		nombre = "Argentinos :)"
		lat = -34.6078057
		lon = -58.4763221
		canchas = #[argen1, argen2]
		nombreDuenio = "No se mi nombre"
		email = "niIdea@noSe.com"
		direccion = "Sarasa 123"
	]

	Partido partido1 = new Partido() => [
		id = "P1"
		owner = sebaCapo
		equipo1 = equipazo
		equipo2 = equipoMalo
		empresa = empresaUrquiza
		canchaReservada = urquiza1
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 5, 27), LocalTime.of(20, 00))
	]

	Partido partido2 = new Partido() => [
		id = "P2"
		owner = andy
		equipo1 = equipazo
		equipo2 = equipoIncompleto
		empresa = empresaVicenteLopez
		canchaReservada = vicLop2
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 4, 24), LocalTime.of(17, 00))
	]

	def runBootstrap() {
		repoUsuarios.create(sebaCapo)
		repoUsuarios.create(nikoBostero)
		repoUsuarios.create(andy)
		repoUsuarios.create(jugador1)
		repoUsuarios.create(jugador2)
		repoUsuarios.create(jugador3)
		repoUsuarios.create(jugador4)

		repoPartido.create(partido1)
		repoPartido.create(partido2)

		repoEquipo.create(equipazo)
		repoEquipo.create(equipoMalo)
		repoEquipo.create(equipoIncompleto)
	}

}
