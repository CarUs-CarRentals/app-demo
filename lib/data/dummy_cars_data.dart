import 'package:carshare/models/car.dart';
import 'package:carshare/models/user_list.dart';

List<Car> dummyCars = [
  Car(
    id: '1',
    user: UserList().userByID(1),
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
    color: 'Preto',
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
    user: UserList().userByID(1),
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
    year: 2016,
    location: CarLocation(
        latitude: -26.9069,
        longitude: -49.0760,
        address:
            "R. São Paulo, 1147 - Victor Konder, Blumenau - SC, 89012-001, Brazil"),
  ),
  Car(
    id: '3',
    user: UserList().userByID(2),
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
    year: 2023,
    description: 'Baita carro de tiozão, muito bom tbm.',
    location: CarLocation(
        latitude: -26.8958,
        longitude: -49.2484,
        address: "R. Timbó, 337 - Rio Morto, Indaial - SC, 89130-000, Brazil"),
  ),
  Car(
    id: '4',
    user: UserList().userByID(3),
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
    color: 'Preto',
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
    user: UserList().userByID(3),
    model: 'Fusca',
    imagesUrl: CarImages(imageUrl: [
      'https://lh3.googleusercontent.com/fife/AAbDypB8btAs0Hc4Gt627RIPvpY2cEbKt3Gq0zBE-zIKm-cINyh6QYEeoPUl1Vac0RLSHeJZr2PpP4BoHtL14zMBKnD0eMDSyWastl-qQp0fXe9VD_fmkYU0ZiA-anvZ0ROkTTS6gFdR8EotmtXk7BIOg5oDgtSM1mKI5cCOJSwq3diy1ZJEc4wUXkGYgjLFc229AsdXwU14TUVDI0aZGLeIkAJZuvtbbrOyQwB3g5TzKktpl7RSDaZzqxFUkIAkf3xRCxJsYiiEUQv7OaxHL7w82BPXiK8Hmms4aLCbWznF9pHWnES36Hdt5XhjFMwBukHLutLEBkP8zCRATQ-Bgm_SXp84U9j-dW-osPemrX5D5__hKz3EzKEmoR0VhEQTzqcGz5dE59mquUJCPkkkwQ3stNNDGKD09Ramnh4OC_oTBtt-o1o7gNDixVi2aoLWBlMGl2CTmRT62nCiwXoGyNn0SzIznD5XgM4oTbGRP_0qcNeBMSmogHIanOi0mTXP_DOOvfrb926Y43uPRQ8QOXXkcpgXCKrpMLVQBzGcztPX7ObRjvce9WwznCJqhxEIpfqkT_NLjjowW6MmSFq_iRrUcjmHJeCXHjMJ36x0FAdlJRXav8IOR4QeJWzWf0VSQzjf-ZNVik8Vu8r2Y3Hz1H3cBEZGIHw2l5PvSY3n6BaypneKcyky6cNP5Y3tqZFI8-nt1QcherLpfnoqKa9vuq8QwITIhaJcGKkdMGLE-OE3AdlRTCfbi_WQK0vguIJvMdcSOUlqI55D1F-1YGZV5vE5fLvCrTIEGU3IYKHefCgU5guWPQOY9ivXwwuD2VduPAOc7FsqfchnSzBsPxY00nPMB-4sh_q5al5ldk7M2R5KfcKaPKbOhueRZ5xVFOGCTU6U964IbwHuN3WyRFbGs7rYBq3q-JS1Lrb1GX1paVgtryaANU3jaycghBpumc2f4kGRJdFwUYQ_lflLrudzHjymBG-lc6YKpSAV9FIG-owUNBG_SMiFLp6b0-g0VWRB3FQ8o6UvPUqOnl5z-JTF1by_xO9J9tS6bPmpN1bzGWAJPAPuh3NOI87T0-fNmiKtqY8aI9qFUKG8DFLYV4TO7WUa3Rbwlmm0mel_qDnmbST1nibtTk2q5CF2NQNdmhm-ikf9F3z4FB1Lk2_ipkaoYOvpp1KyJ96MFSLmOo0ZxWN5pO-HEHFhYzxm3hBUaah37gxDjG8AfB9bSZGsjOWnrbjZD82QbVA6RE4w0JIldvyltAg6qq-czGmafThLjTpVqduXBao7bcBiyR6ZoTmfyNK496OZM8nK9kvzqgg4AZphXE1nzHKQ0eGBaNlXIYz8Wt5aJDsRIwxxHJE3OyS5EIY3XrAOGVAP8MF9a2zHCBALKmfzKY94jsJdEpn4225RsTx0ZVadXZgMZX6_Yn1KI0DN_vek7rRZ6wiqldgvF785HK34ip5pKtyYfzDBi8Gjle1FMC_yHmMEPKo6=w1920-h937',
      'https://lh3.googleusercontent.com/fife/AAbDypCQsYRiHfpcM8jguLaf8SfrbWcmzitlXJHH4oYO3s-_RbmLjtQDl63TVQcpU4mtR8tsazx0UYKXFW16EEARfpwtWKRTClj6PxKVRI4sCI64PwDOGOEnPdOkoeVW_vpiVSmVvFEM0zxzPWYuZICw0rZFgFVzNf9SYFD1hVNFRZLoWNQ0MAkZYFPVfvEOWKmti6V2RvRk06dYKYtyv4vTOJAr9BJcrSArIFzzjmRTZzdX6Dk7e14OJOusQF8BAkGxuuzVKM86aCZrCjcoi0NSu0MYoNQilrqfKtLl3TTTJ56ZjgFREJSdZ7N07TEvyywaxCta3FgcqW9e4yardOesMB1sGGFYAIug8P6MQnQcm_8kxZ4VLY004pKh0ubF57okgt-lS-qTP6gZYVRLYl4HUpBxQVZ2yMGvnNPAV5_RmomWHY_-dG06789P_AM3MZG2Sj_LoMTQ-AaegntWtM1kIm_sfIZqDLYai6HRLQFtvZTDgE5cHKecEQtSvnr24VRRpmEIdHdsJyB6btlV1tIh8b9l61w9XHpb7xThIG9ENgRC-3wSkLdxbaj2DjZgt-jLrNLlofOw6qTLo4agQWF67eiF5BDaUJ7TS5gvvH_8KmSXKXiff1k0E2ccdK6AU8ApZtn8Qumyt8hioGz6zNISuvWtEM6AvdHYAcEquVYedjaDidb_UmCNbVr4hQlZPInX3q5uTNatPgPI0nU3rdVclnCPVvoSLxkDbTzuz_U5GhUQi6DXs5sEN0J7ZT1L7CbF8tBTuoU8_tVS9_L44DDY2SMyRzVM_jTfiSnmzVNBmS_bNp_MyZ7qXGyZtWsupz6bYeR2soRzUwr3BS0Pwr7zXnDAj8nMMEzdUt-shTiPGrG2vedEuFuEH0MFjKgkqWMzqYI8TZW-Vy64Kx45K6_-dkt2VZttC9QoMC0TuPsY3Mp05WuAEM-Bc07nSuucNU28PGxGS2rPJYmpIeQbk8x_5O7SJzjASRkOU_B-naq2NZQPXkHef5NR73gW4vZVxAouYRoZnfHUlMC2II1qoWg2Tgy4HWsIs4X0YDObMHMsz2no3OQuux9jYYsHUMIq08NRrA14wofClsVjJc_wsjDI1A3EoHgFgugmEXBvgWE_eaRoEFI8bjXPdm5FmSWOHOk6u--9ULlrv1jE3wrn_kZN99wURz5a6gdLVA9S4xOGvuWtOViFsII_etqvnUN9oFJxttsMdpOGKGoILLf34HCF4wM2TKCnj848g3adWY7ylGp4R4Lg19fmmJJ8WCSstaqxGJl4pUvmdSBRI3IIXhkZxXovVdbEVLbM0-ChlNc0P_VwvyI-ZSChEhnJ5tVyXJBKZC0x7_tGLi5RyGLubKDL-FpiCRYgkSNrIXuaJyKHYWgf09XXrZYJsvl1KHP4WRGsuy8qy6Bre77nKG87wl1Gt327BgqI2ty-4C0Ohs_laDu4LSx3TUrgqsUsEr_VY9BAHeUVBxAVP63N=w1920-h937',
      'https://lh3.googleusercontent.com/fife/AAbDypAHwm5m6c_91kEw3XQsbWSo_8wXBXyLkHuy8PtaEGGd1twz7t6owT-9G63-dslP_aCr4X3EEAqszBKD5pKWenDA8e0alqYpUUxHLs2nFwfeT2nb28FW_rmFl9gTXHyaWxreeCNT2Kq3cakshAKiT2I8UhsBRIsY7lVSHQnI1qwghIeAFhZd51XNfO7MnW_O0a9irp-RO8IGbwN2rq56oyziA9uyGkcePTNEtSJzbxVMkdAvNNIHZxESY9geG9xjnOv0bmNTLtFhy0VE9Q_TM_nITTQ1KUYwFRSo02orgfSvJM7XHXVFMkFZr7I6Pnh6F-T5PfXTlDR0KsOG88R34FecANIRIeNPdEXwWXe0w4U5ww91DCMjpbka3pIRx3xqAZJGEo0tqMp1xDpKa9t_IttBxvqj5XpXBWHABRCUJ1gc9E_hbwwJxjrjgc_QdKKxtL8TF7UycWbs2qPlloi6rSjitz2V-DFpKoRnNLZJE9vKBPaZbwTehNM7sZlld599GDzjzlep-eyxYwIwwrnY8y4zj9QZfewpNOcvB9qlF3hPSU4mQaEoksmNwPEBFEuQLZ5-CAe_dfDUMEvWemibih-k82SgbWIyYgK-_-grMAqJ2o6obsjYM7DAx0Y0xdJrTpgJ3O-bso_saBwkmzGxxM15ycC0gMeLUIQ5ZgpmFrwTCFIoJkqo8C4Yvnln4q48wnCECsL-tw55WVLcf8L2qZ-qzGcyPkOn_lodOFuBCx5NxCmY8gi-jfoPr1uWsRcgdkm480Yj5OhqATOC09cLx9wvj4H9J81RsiNiv_iQ1cf9BWW4MWG8PTyEdCi5ndGj0suIqpDAWJxv4Iw_QeRspDHEm4SxLsa6gycjNk03ox34xBwdFptXn66K_epZZI4SqwBJYWbX83zIufdtTPp_3Sjj9huIy9w14gbazmCHtJLQq-JEYDdfyTy74ZxDQef8a0Nzs3ZABqqvkeJl0sLlEOsCsOC_HvHvE4DW44y880DIYaPnkCGD6Uqh5muM7Ta-30KeRAKuihcU5H3xV7zpKfjtcGK89o-34wUE77f_Q1BZ-Vz870fQbHXN5rdDszbk5mUWgkT-xBLLVCWPT3t0uyiP133bea2EomtwjSC8uH0J8R8rqlb933Bzk0n7Zgj04fFCEmTofPYO5aQjMXi0UXirNL2B0FjLybqzOBp4DbS3YSPA_Zov2lKD7pkDyRIFYR9sW_K8bGkA3bq7hvo3wkRKwdFPhbuSS10Nm-mfQ9hLd6CgA5tonlpKHlB68dAbyEU5H2VmC1BU3U3wbxKOFBrNJOqts8d0mnp1ACgRF1UbJUF7fyCJVLxkZ2JFyFLltsRCv0EjOiGgSia5JnjNnFjC4SVRBG_pS1Cd4FMfnpEpgZhhKKqjRM_pQ3e0lFpZmmUNuh2sdNyy5FbsGB7T3wAdn_feJLm31NSod9F7H_T-bk459AbECB7LJ8vJ0YAqPaWRJLJBGr6d=w1920-h937',
    ]),
    price: 99.90,
    review: 4.5,
    brand: 'Volkswagen',
    category: CarCategory.sedan,
    color: 'Branco',
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
