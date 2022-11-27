import 'package:carshare/models/user.dart';
import 'package:location/location.dart';

enum CarFuel {
  GASOLINE,
  DIESEL,
  CNG,
  ETHANOL,
  ELECTRIC,
  HYBRID,
  FLEX,
}

enum CarGearShift {
  MANUAL,
  AUTOMATIC,
  BOTH,
}

enum CarCategory {
  SUV,
  SEDAN,
  HATCHBACK,
  SPORT,
  CONVERTIBLE,
  WAGON,
  TRUCK,
}

class CarLocation {
  final double latitude;
  final double longitude;
  final String address;

  const CarLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class CarImages {
  String url;

  CarImages({required this.url});
  CarImages.fromJson(Map<String, dynamic> json) : url = json['url'];

  // method
  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}

class Car {
  final int id;
  final String brand;
  final int doors;
  final CarFuel fuel;
  final CarGearShift gearShift;
  final String model;
  final String plate;
  final CarCategory category;
  final int seats;
  final int trunk;
  final int year;
  final String userId;
  final List<CarImages> imagesUrl;
  final double price;
  //final double review;
  final String description;
  int distance;
  String distanceText;
  final CarLocation location;

  Car(
      {this.id = 0,
      required this.brand,
      required this.doors,
      required this.fuel,
      required this.gearShift,
      required this.plate,
      required this.seats,
      required this.trunk,
      required this.year,
      required this.userId,
      required this.category,
      required this.model,
      required this.imagesUrl,
      required this.price,
      this.description = '',
      this.distance = 0,
      this.distanceText = '',
      required this.location});

  set setCurrentDistance(int distance) {
    this.distance = distance;
  }

  String get shortDescription {
    return '$brand $model';
  }

  static String getGearShiftText(CarGearShift gearShift) {
    switch (gearShift) {
      case CarGearShift.AUTOMATIC:
        return 'Automático';
      case CarGearShift.MANUAL:
        return 'Manual';
      case CarGearShift.BOTH:
        return 'Ambos';
      default:
        return 'Desconhecido';
    }
  }

  static String getFuelText(CarFuel fuel) {
    switch (fuel) {
      case CarFuel.GASOLINE:
        return 'Gasolina';
      case CarFuel.DIESEL:
        return 'Diesel';
      case CarFuel.CNG:
        return 'GNV';
      case CarFuel.ELECTRIC:
        return 'Elétrico';
      case CarFuel.ETHANOL:
        return 'Etanol';
      case CarFuel.HYBRID:
        return 'Híbrido';
      case CarFuel.FLEX:
        return 'Flex';
      default:
        return 'Desconhecido';
    }
  }

  static String getCategoryText(CarCategory category) {
    switch (category) {
      case CarCategory.SUV:
        return 'SUV';
      case CarCategory.SEDAN:
        return 'Sedã';
      case CarCategory.HATCHBACK:
        return 'Hatch';
      case CarCategory.SPORT:
        return 'Esportivo';
      case CarCategory.CONVERTIBLE:
        return 'Conversível';
      case CarCategory.WAGON:
        return 'Perua';
      case CarCategory.TRUCK:
        return 'Picape';
      default:
        return 'Desconhecido';
    }
  }

  // String get categoryText {
  //   switch (category) {
  //     case CarCategory.SUV:
  //       return 'SUV';
  //     case CarCategory.SEDAN:
  //       return 'Sedã';
  //     case CarCategory.HATCHBACK:
  //       return 'Hatch';
  //     case CarCategory.SPORT:
  //       return 'Esportivo';
  //     case CarCategory.CONVERTIBLE:
  //       return 'Conversível';
  //     case CarCategory.WAGON:
  //       return 'Perua';
  //     case CarCategory.TRUCK:
  //       return 'Picape';
  //     default:
  //       return 'Desconhecido';
  //   }
  // }

  // String get fuelText {
  //   switch (fuel) {
  //     case CarFuel.GASOLINE:
  //       return 'Gasolina';
  //     case CarFuel.DIESEL:
  //       return 'Diesel';
  //     case CarFuel.CNG:
  //       return 'GNV';
  //     case CarFuel.ELECTRIC:
  //       return 'Elétrico';
  //     case CarFuel.ETHANOL:
  //       return 'Etanol';
  //     case CarFuel.HYBRID:
  //       return 'Híbrido';
  //     case CarFuel.FLEX:
  //       return 'Flex';
  //     default:
  //       return 'Desconhecido';
  //   }
  // }

  // String get gearShiftText {
  //   switch (gearShift) {
  //     case CarGearShift.AUTOMATIC:
  //       return 'Automático';
  //     case CarGearShift.MANUAL:
  //       return 'Manual';
  //     default:
  //       return 'Desconhecido';
  //   }
  // }
}
