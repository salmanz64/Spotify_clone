import 'dart:convert';
import 'dart:io';

import 'package:client/core/costants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedImage,
    required File selectedAudio,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstants.serverUrl}/song/upload'),
      );

      /*  the .. is essential if fields needs to be added as well*/
      request
        ..files.addAll([
          await http.MultipartFile.fromPath('song', selectedAudio.path),
          await http.MultipartFile.fromPath('thumbnail', selectedImage.path),
        ])
        ..fields.addAll({
          'artist': artist,
          'song_name': songName,
          'hex_code': hexCode,
        })
        ..headers.addAll({'x-auth-token': token});

      final res = await request.send();
      if (res.statusCode != 201) {
        return Left(AppFailure(await res.stream.bytesToString()));
      }
      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<Song>>> getAllSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${ServerConstants.serverUrl}/song/list'),
        headers: {'Content-type': 'application/json', 'x-auth-token': token},
      );

      var resBody = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBody = resBody as Map<String, dynamic>;
        return Left(AppFailure(resBody['detail']));
      }

      resBody = resBody as List;

      List<Song> songs = [];
      for (final song in resBody) {
        songs.add(Song.fromMap(song));
      }
      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favSong({
    required String songId,
    required String token,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${ServerConstants.serverUrl}/song/favorite'),
        headers: {'Content-type': 'application/json', 'x-auth-token': token},
        body: jsonEncode({'song_id': songId}),
      );

      var resBody = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBody = resBody as Map<String, dynamic>;
        return Left(AppFailure(resBody['detail']));
      }

      return Right(resBody['message']);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<Song>>> getAllFavSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${ServerConstants.serverUrl}/song/list/favorites'),
        headers: {'Content-type': 'application/json', 'x-auth-token': token},
      );

      var resBody = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBody = resBody as Map<String, dynamic>;
        return Left(AppFailure(resBody['detail']));
      }

      resBody = resBody as List;

      List<Song> songs = [];
      for (final song in resBody) {
        songs.add(Song.fromMap(song['song']));
      }
      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
