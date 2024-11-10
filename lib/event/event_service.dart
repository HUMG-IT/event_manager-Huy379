import 'package:event_manager/event/event_model.dart';
import 'package:localstore/localstore.dart';

class EventService {
  final db = Localstore.getInstance(useSupportDir: true);

  // Tên collection trong localstore (giống như tên bảng)
  final path = 'event';

  //hàm lấy danh sách sự kiện lên localstore 
  Future<List<EventModel>> getAllEvents() async{
    final eventsMap = await db.collection(path).get();

    if (eventsMap != null) {
      return eventsMap.entries.map((entry) {
        final eventData = entry.value as Map<String, dynamic>;
        if (!eventData.containsKey('id')){
          eventData['id'] = entry.key.split('/').last;
        }
        return EventModel.fromMap(eventData);
      }).toList();
    }
    return[]; 
  }

  // hàm lưu một sự kiện vào localstore
  Future<void> saveEvent(EventModel item) async {
    // Nếu id không tồn tại (tạo mới) thì lấy một id ngẫu nhiên
    item.id ??= db.collection(path).doc().id;
    await db.collection(path).doc(item.id).set(item.toMap());
  }

  // hàm xóa một sự kiện từ localstore
  Future<void> deleteEvent(EventModel item) async {
    await db.collection(path).doc(item.id).delete();
  }

}