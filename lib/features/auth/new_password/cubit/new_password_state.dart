// الكلاس الأساسي للحالات. لا يحتوي على أي شيء،
// وظيفته فقط هي تجميع كل الحالات تحت نوع واحد.
abstract class NewPasswordState {
  const NewPasswordState();
}

/// الحالة الابتدائية: عندما يتم تحميل الشاشة لأول مرة.
class NewPasswordInitial extends NewPasswordState {}

/// حالة التحميل: أثناء تنفيذ طلب الـ API.
class NewPasswordLoading extends NewPasswordState {}

/// حالة النجاح: عند نجاح تحديث كلمة المرور.
class NewPasswordSuccess extends NewPasswordState {}

/// حالة الفشل: عند حدوث خطأ.
class NewPasswordFailure extends NewPasswordState {
  final String errorMessage;

  const NewPasswordFailure({required this.errorMessage});

  // يمكنك اختياريًا إعادة تعريف operator== و hashCode إذا واجهت مشاكل
  // في إعادة البناء غير الضرورية للواجهة، لكنها ليست ضرورية للبدء.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NewPasswordFailure &&
      other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => errorMessage.hashCode;
}