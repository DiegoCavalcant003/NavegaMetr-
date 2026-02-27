class RouteModel {
  final String origem;
  final String destino;
  final String dataHora;

  RouteModel({
    required this.origem,
    required this.destino,
    required this.dataHora,
  });

  Map<String, dynamic> toJson() {
    return {
      'origem': origem,
      'destino': destino,
      'dataHora': dataHora,
    };
  }

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      origem: json['origem'],
      destino: json['destino'],
      dataHora: json['dataHora'],
    );
  }
}