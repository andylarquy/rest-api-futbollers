package ar.edu.unsam.proyecto.webApi.jsonViews

class ViewsEmpresa {
	static class DefaultView {}
	static class DetallesView extends DefaultView {}
	static class SetupView extends DetallesView{}
	static class ListView extends DefaultView {}
}