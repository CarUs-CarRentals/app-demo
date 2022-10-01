import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';

const dummyCars = [
  Car(
    id: '1',
    model: 'Ka',
    imagesUrl: CarImages(imageUrl: [
      'http://s.glbimg.com/jo/g1/f/original/2011/07/03/avaliacao_02.jpg',
      'http://s.glbimg.com/jo/g1/f/original/2011/07/03/avaliacao_01.jpg',
      'http://s.glbimg.com/jo/g1/f/original/2011/07/03/avaliacao_03_.jpg',
    ]),
    price: 199.99,
    review: 4.5,
    brand: 'Ford',
    category: CarCategory.hatchback,
    color: 'Preto',
    doors: 2,
    fuel: CarFuel.petrol,
    gearShift: CarGearShift.manual,
    plate: 'FUU0C47',
    seats: 5,
    trunk: 50,
    userId: 1,
    year: 2012,
    description:
        'Compacto, o Ka tem 3,83 metros de comprimento, 1,42 m de altura, 1.81 m de largura e 2,45 m de distância entre-eixos. A capacidade do porta-malas é de 263 litros e a do tanque de combustível é de 45 litros.',
    location: CarLocation(
        latitude: -26.7376,
        longitude: -49.1744,
        address:
            "Rua Hermann Weege, 151 - Centro, Pomerode - SC, 89107-000, Brazil"),
  ),
  Car(
    id: '2',
    model: 'Argo',
    imagesUrl: CarImages(imageUrl: [
      'https://s2.glbimg.com/UJjVWZEe2D_61_QxwVGSBg__22o=/0x0:620x413/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_cf9d035bf26b4646b105bd958f32089d/internal_photos/bs/2020/v/Y/t3nvI4QxevsA3Nucd3eg/2017-05-31-fiat-argo-hgt-18-opening-edition-mopar-3.jpg',
      'https://s2.glbimg.com/x-oPXdx0tllFO5zxeeYnWXUhPEQ=/0x0:620x413/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_cf9d035bf26b4646b105bd958f32089d/internal_photos/bs/2020/8/2/h95BbUQ1mOkYFoI9Jglw/2017-05-31-fiat-argo-hgt-18-at-4.jpg',
    ]),
    price: 159.75,
    review: 3,
    brand: 'Fiat',
    category: CarCategory.hatchback,
    color: 'Preto',
    doors: 4,
    fuel: CarFuel.petrol,
    gearShift: CarGearShift.manual,
    plate: 'FDA0C48',
    seats: 5,
    trunk: 50,
    userId: 1,
    year: 2016,
    location: CarLocation(
        latitude: -26.9069,
        longitude: -49.0760,
        address:
            "R. São Paulo, 1147 - Victor Konder, Blumenau - SC, 89012-001, Brazil"),
  ),
  Car(
    id: '3',
    model: 'Corolla',
    imagesUrl: CarImages(imageUrl: [
      'https://motorshow.com.br/wp-content/uploads/sites/2/2022/06/29-toyota-corolla-747x420.jpg'
    ]),
    price: 359.75,
    review: 5,
    brand: 'Toyota',
    category: CarCategory.sedan,
    color: 'Branco',
    doors: 4,
    fuel: CarFuel.petrol,
    gearShift: CarGearShift.automatic,
    plate: 'FDG2C58',
    seats: 5,
    trunk: 300,
    userId: 2,
    year: 2023,
    description: 'Baita carro de tiozão, muito bom tbm.',
    location: CarLocation(
        latitude: -26.8958,
        longitude: -49.2484,
        address: "R. Timbó, 337 - Rio Morto, Indaial - SC, 89130-000, Brazil"),
  )
];
