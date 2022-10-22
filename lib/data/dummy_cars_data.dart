import 'package:carshare/models/car.dart';

List<Car> dummyCars = [
  Car(
    id: '1',
    userId: "yiKoZG8TSUhv1fd7W572vAn46M02",
    brand: 'Ford',
    model: 'Ka',
    imagesUrl: CarImages(imageUrl: [
      'http://s.glbimg.com/jo/g1/f/original/2011/07/03/avaliacao_02.jpg',
      'http://s.glbimg.com/jo/g1/f/original/2011/07/03/avaliacao_01.jpg',
      'http://s.glbimg.com/jo/g1/f/original/2011/07/03/avaliacao_03_.jpg',
    ]),
    year: 2012,
    plate: 'FUU0C47',
    fuel: CarFuel.petrol,
    gearShift: CarGearShift.manual,
    category: CarCategory.hatchback,
    trunk: 50,
    doors: 2,
    seats: 5,
    price: 199.99,
    review: 4.5,
    description:
        'Compacto, o Ka tem 3,83 metros de comprimento, 1,42 m de altura, 1.81 m de largura e 2,45 m de distância entre-eixos. A capacidade do porta-malas é de 263 litros e a do tanque de combustível é de 45 litros.',
    location: CarLocation(
        latitude: -26.7376,
        longitude: -49.1744,
        address:
            "Rua Hermann Weege, 151 - Centro, Pomerode - SC, 89107-000, Brasil"),
  ),
  Car(
    id: '2',
    userId: "TgLAhXEwFndGYCoucrbdpafGc2k1",
    model: 'Argo',
    imagesUrl: CarImages(imageUrl: [
      'https://s2.glbimg.com/UJjVWZEe2D_61_QxwVGSBg__22o=/0x0:620x413/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_cf9d035bf26b4646b105bd958f32089d/internal_photos/bs/2020/v/Y/t3nvI4QxevsA3Nucd3eg/2017-05-31-fiat-argo-hgt-18-opening-edition-mopar-3.jpg',
      'https://s2.glbimg.com/x-oPXdx0tllFO5zxeeYnWXUhPEQ=/0x0:620x413/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_cf9d035bf26b4646b105bd958f32089d/internal_photos/bs/2020/8/2/h95BbUQ1mOkYFoI9Jglw/2017-05-31-fiat-argo-hgt-18-at-4.jpg',
    ]),
    price: 159.75,
    review: 3,
    brand: 'Fiat',
    category: CarCategory.hatchback,
    doors: 4,
    fuel: CarFuel.petrol,
    gearShift: CarGearShift.manual,
    plate: 'FDA0C48',
    seats: 5,
    trunk: 50,
    year: 2016,
    location: CarLocation(
        latitude: -26.9069,
        longitude: -49.0760,
        address:
            "R. São Paulo, 1147 - Victor Konder, Blumenau - SC, 89012-001, Brazil"),
  ),
  Car(
    id: '3',
    userId: "P9O0G1Ul8BRixV6akx9uNLb5H6A2",
    model: 'Corolla',
    imagesUrl: CarImages(imageUrl: [
      'https://motorshow.com.br/wp-content/uploads/sites/2/2022/06/29-toyota-corolla-747x420.jpg'
    ]),
    price: 359.75,
    review: 5,
    brand: 'Toyota',
    category: CarCategory.sedan,
    doors: 4,
    fuel: CarFuel.petrol,
    gearShift: CarGearShift.automatic,
    plate: 'FDG2C58',
    seats: 5,
    trunk: 300,
    year: 2023,
    description: 'Baita carro de tiozão, muito bom tbm.',
    location: CarLocation(
        latitude: -26.8958,
        longitude: -49.2484,
        address: "R. Timbó, 337 - Rio Morto, Indaial - SC, 89130-000, Brazil"),
  ),
  Car(
    id: '4',
    userId: "lRndMwYM46PRVRmSxlJo1dJxwJb2",
    model: 'Panamera',
    imagesUrl: CarImages(imageUrl: [
      'https://www.carrosnaweb.com.br/imagensbd007/Panamera-turbo-2017-1.jpg',
      'https://www.carrosnaweb.com.br/imagensbd007/Panamera-turbo-2017-2.jpg',
      'https://www.carrosnaweb.com.br/imagensbd007/Panamera-turbo-2017-3.jpg',
      'https://www.carrosnaweb.com.br/imagensbd007/Panamera-turbo-2017-7.jpg',
    ]),
    price: 359.75,
    review: 5,
    brand: 'Porsche',
    category: CarCategory.sedan,
    doors: 4,
    fuel: CarFuel.petrol,
    gearShift: CarGearShift.automatic,
    plate: 'FRTC48',
    seats: 4,
    trunk: 495,
    year: 2020,
    description:
        'Velocidade Maxima 306km/h\nConsumo médio de 6,5km/l\nDevolver com o tanque cheio.',
    location: CarLocation(
        latitude: -26.5074,
        longitude: -49.1288,
        address:
            "Parque Malwee - Rua Wolfgang Weege, 770, Jaraguá do Sul - SC, 89262-000, Brazil"),
  ),
  Car(
    id: '5',
    userId: "yiKoZG8TSUhv1fd7W572vAn46M02",
    model: 'Fusca',
    imagesUrl: CarImages(imageUrl: [
      'https://motortudo.com/wp-content/uploads/2021/07/767a5191-60f1ea82b2090.jpg',
      'https://motortudo.com/wp-content/uploads/2021/07/Volkswagen-Fusca-1964-carros-populares-antigos-11-800x534.jpg',
      'https://motortudo.com/wp-content/uploads/2021/07/Volkswagen-Fusca-1964-carros-populares-antigos-4-800x534.jpg',
    ]),
    price: 99.90,
    review: 4.5,
    brand: 'Volkswagen',
    category: CarCategory.sedan,
    doors: 4,
    fuel: CarFuel.petrol,
    gearShift: CarGearShift.manual,
    plate: 'BCT-7148',
    seats: 5,
    trunk: 141,
    year: 1969,
    description:
        'Tanque de combustível, mais baixo, que permitia melhor acomodação da bagagem, nova caixa de estepe;\nLavador de para-brisa agora preso diretamente na caixa de estepe; uma única caixa de fusíveis no painel (acesso pelo porta malas) com 7 fusíveis; novas cores e banco com faixa central em tecido "pijaminha".',
    location: CarLocation(
        latitude: -26.7603652,
        longitude: -48.6734811,
        address: "R. Manoel Ferreira, 750, Balneário Piçarras - SC, 88380-000"),
  )
];
