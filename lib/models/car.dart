import 'package:location/location.dart';

enum CarFuel {
  petrol,
  diesel,
  cng,
  ethanol,
  electric,
}

enum CarGearShift {
  manual,
  automatic,
}

enum CarCategory {
  suv,
  sedan,
  hatchback,
  sport,
  convertible,
  wagon,
  truck,
}

class Location {
  final double latitude;
  final double longitude;
  final String address;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class Car {
  final String id;
  final String brand;
  final String color;
  final int doors;
  final CarFuel fuel;
  final CarGearShift gearShift;
  final String model;
  final String plate;
  final CarCategory category;
  final int seats;
  final int trunk;
  final int year;
  final int userId;
  final String imageUrl;
  final double price;
  final double review;
  final String description;
  final Location location;

  const Car(
      {required this.brand,
      required this.color,
      required this.doors,
      required this.fuel,
      required this.gearShift,
      required this.plate,
      required this.seats,
      required this.trunk,
      required this.year,
      required this.userId,
      required this.category,
      required this.id,
      required this.model,
      required this.imageUrl,
      required this.price,
      required this.review,
      this.description = '',
      required this.location});

  String get shortDescription {
    return '$brand $model';
  }

  String get categoryText {
    switch (category) {
      case CarCategory.suv:
        return 'SUV';
      case CarCategory.sedan:
        return 'Sedã';
      case CarCategory.hatchback:
        return 'Hatch';
      case CarCategory.sport:
        return 'Esportivo';
      case CarCategory.convertible:
        return 'Conversível';
      case CarCategory.wagon:
        return 'Perua';
      case CarCategory.truck:
        return 'Picape';
      default:
        return 'Desconhecido';
    }
  }

  String get fuelText {
    switch (fuel) {
      case CarFuel.petrol:
        return 'Gasolina';
      case CarFuel.diesel:
        return 'Diesel';
      case CarFuel.cng:
        return 'GNV';
      case CarFuel.electric:
        return 'Elétrico';
      case CarFuel.ethanol:
        return 'Etanol';
      default:
        return 'Desconhecido';
    }
  }

  String get gearShiftText {
    switch (gearShift) {
      case CarGearShift.automatic:
        return 'Automático';
      case CarGearShift.manual:
        return 'Manual';
      default:
        return 'Desconhecido';
    }
  }
}
