import 'package:flutter/material.dart';
import 'package:imdbmoviesapps/Screens/Details/MovieDetails.dart';
import 'package:imdbmoviesapps/Screens/Details/TvSeriesDetail.dart';

class descriptioncheckui extends StatefulWidget {
  var newid;
  var newtype;
  descriptioncheckui(this.newid, this.newtype, {super.key});

  @override
  State<descriptioncheckui> createState() => _descriptioncheckuiState();
}

class _descriptioncheckuiState extends State<descriptioncheckui> {
  Widget checktype() {
    if (widget.newtype.toString() == 'movie') {
      return MovieDetails(
        id: widget.newid,
      );
    } else if (widget.newtype.toString() == 'tv') {
      return TvSeriesDetails(id: widget.newid);
    } else if (widget.newtype.toString() == 'person') {
      // return persondescriptionui(widget.id);
      return errorui(context);
    } else {
      return errorui(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return checktype();
  }
}

Widget errorui(context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Kesalahan'),
    ),
    body: const Center(
      child: Text('Halaman tidak ditemukan'),
    ),
  );
}

