import 'dart:io';

import 'package:googleapis/run/v2.dart';
import 'package:googleapis/storage/v1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/firestore/v1.dart';
//import 'package:googleapis/cloud_run/v1.dart';

// 设置 Google Cloud 的认证信息
final _serviceAccount = ServiceAccount.fromJson({
  "type": "service_account",
  "project_id": "your-project-id",
  "private_key_id": "your-private-key-id",
});

final _httpClient = await clientViaServiceAccount(_serviceAccount as ServiceAccountCredentials, FirestoreApi.SCOPES);


void main() async {
  final router = Router();

  // 使用 shelf_router 设置路由
  router.get('/', (Request request) {
    return Response.ok('Hello, World!');
  });

  // 使用 Google Cloud Firestore API
  final firestoreApi = FirestoreApi(_httpClient);
  router.get('/firestore', (Request request) async {
    // ... 使用 firestoreApi 进行操作 ...
    return Response.ok('Firestore operation completed.');
  });

  // 使用 Google Cloud Run API
  final cloudRunApi = CloudRunApi(_httpClient);
  router.get('/cloud-run', (Request request) async {
    // ... 使用 cloudRunApi 进行操作 ...
    return Response.ok('Cloud Run operation completed.');
  });

  // 设置静态文件服务
  var shelf_static;
  final staticHandler = shelf_static.createStaticHandler('public');
  router.get('/static/*', staticHandler);

  // 启动服务器
  final server = await shelf_io.serve(router, InternetAddress.anyIPv4, 8080);
  print('Server started on port ${server.port}');
}
