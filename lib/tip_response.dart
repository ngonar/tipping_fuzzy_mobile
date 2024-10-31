class TipResponse {
  final double tip;

  const TipResponse({required this.tip});

  factory TipResponse.fromJson(Map<String, dynamic> json) {
    return TipResponse(
        tip: json['tip'] as double
    );
  }



}