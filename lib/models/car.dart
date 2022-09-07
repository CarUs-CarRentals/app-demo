enum Fuel {
  petrol,
  diesel,
  cng,
  ethanol,
  electric,
}

enum GearShift {
  manual,
  automatic,
}

enum Category {
  suv,
  sedan,
  hatchback,
  sport,
  convertible,
  wagon,
  truck,
}

class Car {
  final String id;
  final String brand;
  final String color;
  final int doors;
  final Fuel fuel;
  final GearShift gearShift;
  final String model;
  final String plate;
  final Category category;
  final int seats;
  final int trunk;
  final int year;
  final int userId;
  final String imageUrl;
  final double price;
  final int review;
  final String description;

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
      this.description = ''});

  String get shortDescription {
    return '$brand $model';
  }

  String get categoryText {
    switch (category) {
      case Category.suv:
        return 'SUV';
      case Category.sedan:
        return 'Sedã';
      case Category.hatchback:
        return 'Hatch';
      case Category.sport:
        return 'Esportivo';
      case Category.convertible:
        return 'Conversível';
      case Category.wagon:
        return 'Perua';
      case Category.truck:
        return 'Picape';
      default:
        return 'Desconhecido';
    }
  }

  String get fuelText {
    switch (fuel) {
      case Fuel.petrol:
        return 'Gasolina';
      case Fuel.diesel:
        return 'Diesel';
      case Fuel.cng:
        return 'GNV';
      case Fuel.electric:
        return 'Elétrico';
      case Fuel.ethanol:
        return 'Etanol';
      default:
        return 'Desconhecido';
    }
  }

  String get gearShiftText {
    switch (gearShift) {
      case GearShift.automatic:
        return 'Automático';
      case GearShift.manual:
        return 'Manual';
      default:
        return 'Desconhecido';
    }
  }
}
