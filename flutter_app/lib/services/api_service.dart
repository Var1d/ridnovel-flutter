// Farid Dhiya Fairuz - 247006111058 - B

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/novel_model.dart';
import '../models/user_model.dart';

class ApiService {
  // ⚠️ Untuk emulator Android gunakan: http://10.0.2.2:3000
  // ⚠️ Untuk HP fisik ganti dengan IP laptop kamu: http://192.168.x.x:3000
  static const String baseUrl = 'http://10.0.2.2:3000';

  static Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return User.fromJson(body['data']['user'], body['data']['token']);
    }
    throw Exception(body['message'] ?? 'Login gagal');
  }

  static Future<void> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode != 201) throw Exception(body['message'] ?? 'Registrasi gagal');
  }

  static Future<List<Novel>> getNovels(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/novels'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return (body['data'] as List).map((e) => Novel.fromJson(e)).toList();
    }
    throw Exception(body['message'] ?? 'Gagal mengambil data novel');
  }

  static Future<Novel> getNovelById(String token, int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/novels/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) return Novel.fromJson(body['data']);
    throw Exception(body['message'] ?? 'Gagal mengambil detail novel');
  }

  static Future<Novel> createNovel(String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/novels'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(data),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 201) return Novel.fromJson(body['data']);
    throw Exception(body['message'] ?? 'Gagal menambahkan novel');
  }

  static Future<Novel> updateNovel(String token, int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/novels/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(data),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) return Novel.fromJson(body['data']);
    throw Exception(body['message'] ?? 'Gagal mengupdate novel');
  }

  static Future<void> deleteNovel(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/novels/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    final body = jsonDecode(response.body);
    if (response.statusCode != 200) throw Exception(body['message'] ?? 'Gagal menghapus novel');
  }
}
