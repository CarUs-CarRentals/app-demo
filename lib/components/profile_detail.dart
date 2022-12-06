import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:carshare/models/review.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/providers/reviews.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileDetail extends StatefulWidget {
  final bool isMyProfile;
  final User user;
  // final String userFullname;
  // final String aboutMe;
  // final String fullAddress;
  const ProfileDetail({
    Key? key,
    required this.isMyProfile,
    // required this.userFullname,
    // required this.aboutMe,
    // required this.fullAddress,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  bool _isLoading = false;
  List<UserReview>? _userReviews;

  _descriptionSection(BuildContext context, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  'Sobre mim:',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
        ],
      ),
    );
  }

  void _selectEditProfile(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.PROFILE_EDIT,
      arguments: widget.user,
    );
  }

  Future<void> _getUserReviews(String userId) async {
    final provider = Provider.of<Reviews>(context, listen: false);
    await provider.loadUserReviewsByUser(userId);
    _userReviews = provider.userReviewsFromUser;

    print("_getUserReviews: ${_userReviews?.length}");
    //_carReviews = provider.carReviewsFromCar;
  }

  Future<void> _selectReviewsReceived(BuildContext context, User user) async {
    setState(() {
      _isLoading = true;
    });
    await _getUserReviews(user.id);
    print("antes de entrar na tela: ${_userReviews?.length}");
    Navigator.of(context).pushNamed(
      AppRoutes.USER_REVIEW,
      arguments: _userReviews,
    );
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _openWhatsapp(String phone) async {
    final whatsapp = "+55$phone";
    var whatsappURL_android = Uri.parse("whatsapp://send?phone=$whatsapp");
    var whatsappURL_ios = Uri.parse("https://wa.me/$whatsapp");

    if (Platform.isIOS) {
      if (await canLaunchUrl(whatsappURL_ios)) {
        await launchUrl(whatsappURL_ios);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Whatsapp não está instalado")));
      }
    } else {
      if (await canLaunchUrl(whatsappURL_android)) {
        await launchUrl(whatsappURL_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Whatsapp não está instalado")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          ListTile(
            trailing: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(widget.user.profileImageUrl),
              backgroundColor: Colors.transparent,
            ),
            title: Text(widget.user.fullName,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                )),
            subtitle:
                Text("membro desde ${widget.user.memberSince.substring(0, 4)}"),
            dense: false,
          ),
          Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: ListTile(
                enabled: !_isLoading,
                leading: Container(
                  width: 24,
                  child: Icon(
                    Icons.reviews,
                    size: 24,
                  ),
                ),
                title: Text(
                  widget.isMyProfile
                      ? widget.user.rateNumber < 2
                          ? "${widget.user.rateNumber} Avaliação"
                          : "${widget.user.rateNumber} Avaliações"
                      : "Avaliações",
                  style: const TextStyle(
                    fontFamily: 'RobotCondensed',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => _selectReviewsReceived(context, widget.user),
                dense: false,
              )),
          _isLoading
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                  ),
                )
              : Divider(),
          _descriptionSection(context, widget.user.about),
          !widget.isMyProfile
              ? widget.user.phone != ""
                  ? ListTile(
                      leading: Container(
                        width: 24,
                        child: Icon(
                          Icons.whatsapp_rounded,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        UtilBrasilFields.obterTelefone(widget.user.phone,
                            mascara: true),
                        style: const TextStyle(
                          fontFamily: 'RobotCondensed',
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        _openWhatsapp(widget.user.phone);
                      },
                      dense: false,
                    )
                  : const Center()
              : const Center(),
          ListTile(
            leading: Container(
              width: 24,
              child: Icon(
                Icons.pin_drop_rounded,
                size: 24,
              ),
            ),
            title: Text(
              widget.user.address != null
                  ? widget.user.address!.fullAddress
                  : '',
              style: const TextStyle(
                fontFamily: 'RobotCondensed',
                fontSize: 14,
              ),
            ),
            dense: false,
          ),
          Divider(),
          if (widget.isMyProfile)
            ElevatedButton(
                onPressed: () => _selectEditProfile(context),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                ),
                child: const Text(
                  'Editar Perfil',
                  style: TextStyle(fontSize: 20),
                )),
        ],
      ),
    );
  }
}
