package ar.edu.unsam.proyecto.dominio

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
import java.util.ArrayList
import java.util.Arrays
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class TestDominioBienFormado {

	RepositorioUsuario repoUsuarios = RepositorioUsuario.instance
	RepositorioPartido repoPartido = RepositorioPartido.instance
	RepositorioEquipo repoEquipo = RepositorioEquipo.instance
	
	LocalDateTime fechaDeReservaPartido1 = LocalDateTime.of(LocalDate.of(2020, 5, 27), LocalTime.of(20, 00))
	LocalDateTime fechaDeReservaPartido2 = LocalDateTime.of(LocalDate.of(2020, 4, 24), LocalTime.of(17, 00))
	LocalDateTime fechaDeReservaPartido3 = LocalDateTime.of(LocalDate.of(2020, 4, 26), LocalTime.of(17, 30))
	LocalDateTime fechaDeReservaPartido4 = LocalDateTime.of(LocalDate.of(2020, 4, 24), LocalTime.of(16, 00))
	
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

	Usuario warrenSanchez = new Usuario() => [
		id = "U8"
		nombre = "Warren Sanchez"
		password = "mandarina"
		sexo = "H"
		posicion = "Arquero"
		foto = "https://i.imgur.com/eKKFfS2.jpg"
		email = "elhalldelteatro@warren.com"
		lat = -34.6010406
		lon = -58.3830786
	]

	Usuario mastropiero = new Usuario() => [
		id = "U9"
		nombre = "Johan Sebastian Mastropiero"
		password = "mandarina"
		sexo = "H"
		posicion = "Delantero"
		foto = "https://i.imgur.com/TTaaxVH.jpg"
		email = "muchasGracias@DeNada.com"
		lat = -34.6010406
		lon = -58.3830786
	]

	Equipo equipazo = new Equipo() => [
		id = "E1"
		nombre = "El equipazo"
		owner = sebaCapo
		foto = "https://i.imgur.com/hccT1z9.jpg"
		integrantes = new ArrayList(Arrays.asList(sebaCapo, nikoBostero, andy, jugador1, jugador2))
	]

	Equipo equipoMalo = new Equipo() => [
		id = "E2"
		nombre = "El equipo malo"
		owner = andy
		foto = "https://i.imgur.com/RhqYpUg.jpg"
		integrantes = new ArrayList(Arrays.asList(jugador1, jugador2, jugador3, jugador4, andy))
	]

	Equipo equipoIncompleto = new Equipo() => [
		id = "E3"
		nombre = "Equipo incompleto"
		owner = nikoBostero
		foto = "https://i.imgur.com/lvR3nt3.jpg"
		integrantes = new ArrayList(Arrays.asList(sebaCapo, nikoBostero, andy))
	]

	Equipo equipoLesLuthier = new Equipo() => [
		id = "E4"
		nombre = "Yo que se, mira lo que me pedis"
		owner = mastropiero
		foto = "https://i.redd.it/kvq6bvmcask31.jpg"
		integrantes = new ArrayList(Arrays.asList(mastropiero, warrenSanchez, andy, jugador1, sebaCapo))
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
		canchas = new ArrayList(Arrays.asList(urquiza1, urquiza2))
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
		canchas = new ArrayList(Arrays.asList(vicLop1, vicLop2, vicLop3))
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
		canchas = new ArrayList(Arrays.asList(argen1, argen2))
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

	Partido partido3 = new Partido() => [
		id = "P3"
		owner = andy
		equipo1 = equipoMalo
		equipo2 = equipoLesLuthier
		empresa = empresaUrquiza
		canchaReservada = urquiza2
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 4, 26), LocalTime.of(17, 30))
	]

	Partido partido4 = new Partido() => [
		id = "P4"
		owner = sebaCapo
		equipo1 = equipoIncompleto
		equipo2 = equipazo
		empresa = empresaUrquiza
		canchaReservada = urquiza1
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 4, 24), LocalTime.of(16, 00))
	]





	@Before
	def void init() {

		repoUsuarios.create(sebaCapo)
		repoUsuarios.create(nikoBostero)
		repoUsuarios.create(andy)
		repoUsuarios.create(jugador1)
		repoUsuarios.create(jugador2)
		repoUsuarios.create(jugador3)
		repoUsuarios.create(jugador4)
		repoUsuarios.create(warrenSanchez)
		repoUsuarios.create(mastropiero)

		repoPartido.create(partido1)
		repoPartido.create(partido2)
		repoPartido.create(partido3)
		repoPartido.create(partido4)

		repoEquipo.create(equipazo)
		repoEquipo.create(equipoMalo)
		repoEquipo.create(equipoIncompleto)
		repoEquipo.create(equipoLesLuthier)

	}





	@After
	def void after() {
		repoUsuarios.reset()
		repoEquipo.reset()
		repoPartido.reset
	}
	
	
	// <<<< TEST - CREDENCIALES DE USUARIOS >>>>
	@Test
	def void sebaCapoTieneCredenciales() {
		Assert.assertTrue(sebaCapo.tieneCredenciales("sebassdevita@gmail.com","mandarina"))
	}
	
	@Test
	def void nikoBosteroTieneCredenciales() {
		Assert.assertTrue(nikoBostero.tieneCredenciales("niko.bostero.232@gmail.com","mandarina"))
	}
	
	@Test
	def void andyTieneCredenciales() {
		Assert.assertTrue(andy.tieneCredenciales("andres27059934@gmail.com","mandarina"))
	}
	
	@Test
	def void jugador1TieneCredenciales() {
		Assert.assertTrue(jugador1.tieneCredenciales("elmaildelnabo1@sarasa.com","mandarina"))
	}
	
	@Test
	def void jugador2TieneCredenciales() {
		Assert.assertTrue(jugador2.tieneCredenciales("elmaildelnabo2@sarasa.com","mandarina"))
	}
	
	@Test
	def void jugador3TieneCredenciales() {
		Assert.assertTrue(jugador3.tieneCredenciales("elmaildelnabo3@sarasa.com","mandarina"))
	}
	
	@Test
	def void jugador4TieneCredenciales() {
		Assert.assertTrue(jugador4.tieneCredenciales("elmaildelnabo4@sarasa.com","mandarina"))
	}
	// <<<</ TEST - CREDENCIALES DE USUARIOS >>>>





	// <<<< TEST - EQUIPAZO >>>>
	@Test
	def void equipazoEstaBienFormado() {
		Assert.assertEquals(#[sebaCapo, nikoBostero, andy, jugador1, jugador2], equipazo.integrantes)
	}

	@Test
	def void ownerDeEquipazo() {
		Assert.assertTrue(equipazo.esOwner(sebaCapo))
	}

	@Test
	def void equipazoIntegranteParticipa1() {
		Assert.assertTrue(equipazo.participaUsuario(nikoBostero))
	}

	@Test
	def void equipazoIntegranteParticipa2() {
		Assert.assertTrue(equipazo.participaUsuario(andy))
	}

	@Test
	def void equipazoIntegranteNoParticipa1() {
		Assert.assertFalse(equipazo.participaUsuario(warrenSanchez))
	}

	@Test
	def void equipazoIntegranteNoParticipa2() {
		Assert.assertFalse(equipazo.participaUsuario(jugador4))
	}

	@Test
	def void equipazoAgregarIntegrante1() {
		equipazo.agregarIntegrante(warrenSanchez)
		Assert.assertEquals(#[sebaCapo, nikoBostero, andy, jugador1, jugador2, warrenSanchez], equipazo.integrantes)
	}

	@Test
	def void equipazoAgregarIntegrante2() {
		equipazo.agregarIntegrante(mastropiero)
		Assert.assertEquals(#[sebaCapo, nikoBostero, andy, jugador1, jugador2, mastropiero], equipazo.integrantes)
	}

	@Test
	def void equipazoQuitarIntegrante1() {
		equipazo.quitarIntegrante(andy)
		Assert.assertEquals(#[sebaCapo, nikoBostero, jugador1, jugador2], equipazo.integrantes)
	}

	@Test
	def void equipazoQuitarIntegrante2() {
		equipazo.quitarIntegrante(sebaCapo)
		Assert.assertEquals(#[nikoBostero, andy, jugador1, jugador2], equipazo.integrantes)
	}
	// <<<</ TEST - EQUIPAZO >>>>
	
	
	
	
	
	
	
	
	// <<<< TEST - EQUIPO MALO >>>>
	@Test
	def void equipoMaloEstaBienFormado() {
		Assert.assertEquals(#[jugador1, jugador2, jugador3, jugador4, andy], equipoMalo.integrantes)
	}

	@Test
	def void ownerDeEquipoMalo() {
		Assert.assertTrue(equipoMalo.esOwner(andy))
	}

	@Test
	def void equipoMaloIntegranteParticipa1() {
		Assert.assertTrue(equipoMalo.participaUsuario(jugador1))
	}

	@Test
	def void equipoMaloIntegranteParticipa2() {
		Assert.assertTrue(equipoMalo.participaUsuario(andy))
	}

	@Test
	def void equipoMaloIntegranteNoParticipa1() {
		Assert.assertFalse(equipoMalo.participaUsuario(nikoBostero))
	}

	@Test
	def void equipoMaloIntegranteNoParticipa2() {
		Assert.assertFalse(equipoMalo.participaUsuario(sebaCapo))
	}

	@Test
	def void equipoMaloAgregarIntegrante1() {
		equipoMalo.agregarIntegrante(warrenSanchez)
		Assert.assertEquals(#[jugador1, jugador2, jugador3, jugador4, andy, warrenSanchez], equipoMalo.integrantes)
	}

	@Test
	def void equipoMaloAgregarIntegrante2() {
		equipoMalo.agregarIntegrante(mastropiero)
		Assert.assertEquals(#[jugador1, jugador2, jugador3, jugador4, andy, mastropiero], equipoMalo.integrantes)
	}

	@Test
	def void equipoMaloQuitarIntegrante1() {
		equipoMalo.quitarIntegrante(andy)
		Assert.assertEquals(#[jugador1, jugador2, jugador3, jugador4], equipoMalo.integrantes)
	}

	@Test
	def void equipoMaloQuitarIntegrante2() {
		equipoMalo.quitarIntegrante(jugador3)
		Assert.assertEquals(#[jugador1, jugador2, jugador4, andy], equipoMalo.integrantes)
	}
	// <<<</ TEST - EQUIPO MALO >>>>
	
	
	
	
	
	
	
	
	// <<<< TEST - EQUIPO INCOMPLETO >>>>
	@Test
	def void equipoIncompletoEstaBienFormado() {
		Assert.assertEquals(#[sebaCapo, nikoBostero, andy], equipoIncompleto.integrantes)
	}

	@Test
	def void ownerDeEquipoIncompleto() {
		Assert.assertTrue(equipoIncompleto.esOwner(nikoBostero))
	}

	@Test
	def void equipoIncompletoIntegranteParticipa1() {
		Assert.assertTrue(equipoIncompleto.participaUsuario(sebaCapo))
	}

	@Test
	def void equipoIncompletoIntegranteParticipa2() {
		Assert.assertTrue(equipoIncompleto.participaUsuario(nikoBostero))
	}

	@Test
	def void equipoIncompletoIntegranteNoParticipa1() {
		Assert.assertFalse(equipoIncompleto.participaUsuario(jugador1))
	}

	@Test
	def void equipoIncompletoIntegranteNoParticipa2() {
		Assert.assertFalse(equipoIncompleto.participaUsuario(mastropiero))
	}

	@Test
	def void equipoIncompletoAgregarIntegrante1() {
		equipoIncompleto.agregarIntegrante(warrenSanchez)
		Assert.assertEquals(#[sebaCapo, nikoBostero, andy, warrenSanchez], equipoIncompleto.integrantes)
	}

	@Test
	def void equipoIncompletoAgregarIntegrante2() {
		equipoIncompleto.agregarIntegrante(mastropiero)
		Assert.assertEquals(#[sebaCapo, nikoBostero, andy, mastropiero], equipoIncompleto.integrantes)
	}

	@Test
	def void equipoIncompletoQuitarIntegrante1() {
		equipoIncompleto.quitarIntegrante(andy)
		Assert.assertEquals(#[sebaCapo, nikoBostero], equipoIncompleto.integrantes)
	}

	@Test
	def void equipoIncompletoQuitarIntegrante2() {
		equipoIncompleto.quitarIntegrante(nikoBostero)
		Assert.assertEquals(#[sebaCapo, andy], equipoIncompleto.integrantes)
	}
	// <<<</ TEST - EQUIPO INCOMPLETO >>>>
	
	
	
	
	
	
	
	
	// <<<< TEST - EQUIPO LES LUTHIER >>>>
	@Test
	def void equipoLesLuthierEstaBienFormado() {
		Assert.assertEquals(#[mastropiero, warrenSanchez, andy, jugador1, sebaCapo], equipoLesLuthier.integrantes)
	}

	@Test
	def void ownerDeEquipoLesLuthier() {
		Assert.assertTrue(equipoLesLuthier.esOwner(mastropiero))
	}
	
	@Test
	def void equipoLesLuthierIntegranteParticipa1() {
		Assert.assertTrue(equipoLesLuthier.participaUsuario(warrenSanchez))
	}

	@Test
	def void equipoLesLuthierIntegranteParticipa2() {
		Assert.assertTrue(equipoLesLuthier.participaUsuario(andy))
	}

	@Test
	def void equipoLesLuthierIntegranteNoParticipa1() {
		Assert.assertFalse(equipoLesLuthier.participaUsuario(nikoBostero))
	}

	@Test
	def void equipoLesLuthierIntegranteNoParticipa2() {
		Assert.assertFalse(equipoLesLuthier.participaUsuario(jugador3))
	}

	@Test
	def void equipoLesLuthierAgregarIntegrante1() {
		equipoLesLuthier.agregarIntegrante(nikoBostero)
		Assert.assertEquals(#[mastropiero, warrenSanchez, andy, jugador1, sebaCapo, nikoBostero], equipoLesLuthier.integrantes)
	}

	@Test
	def void equipoLesLuthierAgregarIntegrante2() {
		equipoLesLuthier.agregarIntegrante(jugador4)
		Assert.assertEquals(#[mastropiero, warrenSanchez, andy, jugador1, sebaCapo, jugador4], equipoLesLuthier.integrantes)
	}

	@Test
	def void equipoLesLuthierQuitarIntegrante1() {
		equipoLesLuthier.quitarIntegrante(andy)
		Assert.assertEquals(#[mastropiero, warrenSanchez, jugador1, sebaCapo], equipoLesLuthier.integrantes)
	}

	@Test
	def void equipoLesLuthierQuitarIntegrante2() {
		equipoLesLuthier.quitarIntegrante(warrenSanchez)
		Assert.assertEquals(#[mastropiero, andy, jugador1, sebaCapo], equipoLesLuthier.integrantes)
	}
	// <<<</ TEST - EQUIPO INCOMPLETO >>>>
	
	
	
	
	
	
	
	
	// <<<< TEST - EMPRESA URQUIZA >>>>
	@Test
	def void empresaUrquizaEstaBienFormada() {
		Assert.assertEquals("Aguante uqz", empresaUrquiza.nombre)
		Assert.assertEquals("Tito Bara", empresaUrquiza.nombreDuenio)
		Assert.assertEquals("Roosevelt 5110", empresaUrquiza.direccion)
		Assert.assertEquals(#[urquiza1, urquiza2], empresaUrquiza.canchas)
	}
	
	@Test 
	def void urquizaAgregarCancha1(){
		empresaUrquiza.agregarCancha(vicLop1)
		Assert.assertEquals(#[urquiza1, urquiza2, vicLop1], empresaUrquiza.canchas)
	}

	@Test 
	def void urquizaAgregarCancha2(){
		empresaUrquiza.agregarCancha(argen1)
		Assert.assertEquals(#[urquiza1, urquiza2, argen1], empresaUrquiza.canchas)
	}
	// <<<</ TEST - EMPRESA URQUIZA >>>>
	
	
	
	
	
	
	
	
	// <<<< TEST - EMPRESA VICENTE LOPEZ >>>>
	@Test
	def void empresaVicenteLopezEstaBienFormada() {
		Assert.assertEquals("Queda en la loma del orto", empresaVicenteLopez.nombre)
		Assert.assertEquals("Jorge", empresaVicenteLopez.nombreDuenio)
		Assert.assertEquals("Mitre 3847", empresaVicenteLopez.direccion)
		Assert.assertEquals(#[vicLop1, vicLop2, vicLop3], empresaVicenteLopez.canchas)
	}
	
	@Test 
	def void vicenteLopezAgregarCancha1(){
		empresaVicenteLopez.agregarCancha(urquiza1)
		Assert.assertEquals(#[vicLop1, vicLop2, vicLop3, urquiza1], empresaVicenteLopez.canchas)
	}

	@Test 
	def void vicenteLopezAgregarCancha2(){
		empresaVicenteLopez.agregarCancha(argen1)
		Assert.assertEquals(#[vicLop1, vicLop2, vicLop3, argen1], empresaVicenteLopez.canchas)
	}
	// <<<</ TEST - EMPRESA VICENTE LOPEZ >>>>
		
	
	
	
	
	
	
	
	// <<<< TEST - EMPRESA VICENTE LOPEZ >>>>
	@Test
	def void empresaArgentinosEstaBienFormada() {
		Assert.assertEquals("Argentinos :)", empresaArgentinos.nombre)
		Assert.assertEquals("No se mi nombre", empresaArgentinos.nombreDuenio)
		Assert.assertEquals("Sarasa 123", empresaArgentinos.direccion)
		Assert.assertEquals(#[argen1, argen2], empresaArgentinos.canchas)
	}
	
	@Test 
	def void empresaArgentinosAgregarCancha1(){
		empresaArgentinos.agregarCancha(urquiza1)
		Assert.assertEquals(#[argen1, argen2, urquiza1], empresaArgentinos.canchas)
	}

	@Test 
	def voidempresaArgentinosAgregarCancha2(){
		empresaArgentinos.agregarCancha(argen1)
		Assert.assertEquals(#[argen1, argen2, argen1], empresaArgentinos.canchas)
	}
	// <<<</ TEST - EMPRESA VICENTE LOPEZ >>>>
	
	
	
	
	
	
	
	// <<<< TEST - PARTIDO 1 >>>>
	@Test
	def void partido1EstaBienFormado() {
		Assert.assertEquals(sebaCapo, partido1.owner)
		Assert.assertEquals(equipazo, partido1.equipo1)
		Assert.assertEquals(equipoMalo, partido1.equipo2)
		Assert.assertEquals(empresaUrquiza, partido1.empresa)
		Assert.assertEquals(urquiza1, partido1.canchaReservada)
		Assert.assertEquals(fechaDeReservaPartido1, partido1.fechaDeReserva)
	}
	
	@Test
	def void partido1ParticipaSebaCapo() {
		Assert.assertTrue(partido1.participaUsuario(sebaCapo))
	}
	
	@Test
	def void partido1ParticipaAndy() {
		Assert.assertTrue(partido1.participaUsuario(andy))
	}
	
	@Test
	def void partido1NoParticipaMastropiero() {
		Assert.assertFalse(partido1.participaUsuario(mastropiero))
	}
	
	@Test
	def void partido1NoParticipaWarren() {
		Assert.assertFalse(partido1.participaUsuario(warrenSanchez))
	}
	// <<<</ TEST - PARTIDO 1 >>>>
	
	
	
	
	
	
	
	// <<<< TEST - PARTIDO 2 >>>>
	@Test
	def void partido2EstaBienFormado() {
		Assert.assertEquals(andy, partido2.owner)
		Assert.assertEquals(equipazo, partido2.equipo1)
		Assert.assertEquals(equipoIncompleto, partido2.equipo2)
		Assert.assertEquals(empresaVicenteLopez, partido2.empresa)
		Assert.assertEquals(vicLop2, partido2.canchaReservada)
		Assert.assertEquals(fechaDeReservaPartido2, partido2.fechaDeReserva)
	}
	
	@Test
	def void partido2ParticipaSebaCapo() {
		Assert.assertTrue(partido2.participaUsuario(sebaCapo))
	}
	
	@Test
	def void partido2ParticipaAndy() {
		Assert.assertTrue(partido2.participaUsuario(andy))
	}
	
	@Test
	def void partido2NoParticipaMastropiero() {
		Assert.assertFalse(partido2.participaUsuario(mastropiero))
	}
	
	@Test
	def void partido2NoParticipaWarren() {
		Assert.assertFalse(partido2.participaUsuario(warrenSanchez))
	}
	// <<<</ TEST - PARTIDO 2 >>>>
	
	
	
	
	
	
	
	// <<<< TEST - PARTIDO 3 >>>>
	@Test
	def void partido3EstaBienFormado() {
		Assert.assertEquals(andy, partido3.owner)
		Assert.assertEquals(equipoMalo, partido3.equipo1)
		Assert.assertEquals(equipoLesLuthier, partido3.equipo2)
		Assert.assertEquals(empresaUrquiza, partido3.empresa)
		Assert.assertEquals(urquiza2, partido3.canchaReservada)
		Assert.assertEquals(fechaDeReservaPartido3, partido3.fechaDeReserva)
	}
	
	@Test
	def void partido3ParticipaSebaCapo() {
		Assert.assertTrue(partido3.participaUsuario(sebaCapo))
	}
	
	@Test
	def void partido3ParticipaAndy() {
		Assert.assertTrue(partido3.participaUsuario(andy))
	}
	
	@Test
	def void partido3NoParticipaNikoBostero() {
		Assert.assertFalse(partido3.participaUsuario(nikoBostero))
	}
	// <<<</ TEST - PARTIDO 3 >>>>
		
	
	
	
	
	
	
	// <<<< TEST - PARTIDO 4 >>>>
	@Test
	def void partido4EstaBienFormado() {
		Assert.assertEquals(sebaCapo, partido4.owner)
		Assert.assertEquals(equipoIncompleto, partido4.equipo1)
		Assert.assertEquals(equipazo, partido4.equipo2)
		Assert.assertEquals(empresaUrquiza, partido4.empresa)
		Assert.assertEquals(urquiza1, partido4.canchaReservada)
		Assert.assertEquals(fechaDeReservaPartido4, partido4.fechaDeReserva)
	}

	@Test
	def void partido4ParticipaSebaCapo() {
		Assert.assertTrue(partido4.participaUsuario(sebaCapo))
	}
	
	@Test
	def void partido4ParticipaAndy() {
		Assert.assertTrue(partido4.participaUsuario(andy))
	}
	
	@Test
	def void partido4NoParticipaJugador3() {
		Assert.assertFalse(partido4.participaUsuario(jugador3))
	}
	
	@Test
	def void partido4NoParticipaJugador4() {
		Assert.assertFalse(partido4.participaUsuario(jugador4))
	}
	// <<<</ TEST - PARTIDO 4 >>>>
	
}
