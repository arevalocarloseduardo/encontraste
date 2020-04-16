
import 'dart:convert';

class GamePictonary {
    String user;
    List<DataGamePictonary> dataGamePictonary;

    GamePictonary({
        this.user,
        this.dataGamePictonary,
    });

  

    String toJson() => json.encode(toMap());

    factory GamePictonary.fromMap(Map<String, dynamic> json) => GamePictonary(
        user: json["user"],
        dataGamePictonary: List<DataGamePictonary>.from(json["dataGamePictonary"].map((x) => DataGamePictonary.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "user": user,
        "dataGamePictonary": List<dynamic>.from(dataGamePictonary.map((x) => x.toMap())),
    };
}

class DataGamePictonary {
    double dx;
    double dy;

    DataGamePictonary({
        this.dx,
        this.dy,
    });

    factory DataGamePictonary.fromJson(String str) => DataGamePictonary.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DataGamePictonary.fromMap(Map<String, dynamic> json) => DataGamePictonary(
        dx: json["dx"].toDouble(),
        dy: json["dy"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "dx": dx,
        "dy": dy,
    };
}