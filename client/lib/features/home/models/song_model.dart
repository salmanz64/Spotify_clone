// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class Song {
  final String song_name;
  final String song_url;
  final String thumbnail_url;
  final String artist;
  final String hex_code;
  final String id;
  Song({
    required this.song_name,
    required this.song_url,
    required this.thumbnail_url,
    required this.artist,
    required this.hex_code,
    required this.id,
  });

  Song copyWith({
    String? song_name,
    String? song_url,
    String? thumbnail_url,
    String? artist,
    String? hex_code,
    String? id,
  }) {
    return Song(
      song_name: song_name ?? this.song_name,
      song_url: song_url ?? this.song_url,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
      artist: artist ?? this.artist,
      hex_code: hex_code ?? this.hex_code,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'song_name': song_name,
      'song_url': song_url,
      'thumbnail_url': thumbnail_url,
      'artist': artist,
      'hex_code': hex_code,
      'id': id,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      song_name: map['song_name'] ?? '',
      song_url: map['song_url'] ?? '',
      thumbnail_url: map['thumbnail_url'] ?? '',
      artist: map['artist'] ?? '',
      hex_code: map['hex_code'] ?? '',
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) =>
      Song.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Song(song_name: $song_name, song_url: $song_url, thumbnail_url: $thumbnail_url, artist: $artist, hex_code: $hex_code, id: $id)';
  }

  @override
  bool operator ==(covariant Song other) {
    if (identical(this, other)) return true;

    return other.song_name == song_name &&
        other.song_url == song_url &&
        other.thumbnail_url == thumbnail_url &&
        other.artist == artist &&
        other.hex_code == hex_code &&
        other.id == id;
  }

  @override
  int get hashCode {
    return song_name.hashCode ^
        song_url.hashCode ^
        thumbnail_url.hashCode ^
        artist.hashCode ^
        hex_code.hashCode ^
        id.hashCode;
  }
}
