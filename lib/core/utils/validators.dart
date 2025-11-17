/// Form Validation 유틸리티
class Validators {
  Validators._(); // Private constructor

  /// 이메일 검증
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return '올바른 이메일 형식이 아닙니다';
    }

    return null;
  }

  /// 비밀번호 검증
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }

    if (value.length < 8) {
      return '비밀번호는 최소 8자 이상이어야 합니다';
    }

    // 영문, 숫자, 특수문자 포함 확인
    final hasUpperCase = value.contains(RegExp(r'[A-Z]'));
    final hasLowerCase = value.contains(RegExp(r'[a-z]'));
    final hasDigit = value.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUpperCase || !hasLowerCase || !hasDigit || !hasSpecialChar) {
      return '비밀번호는 영문 대소문자, 숫자, 특수문자를 포함해야 합니다';
    }

    return null;
  }

  /// 비밀번호 확인 검증
  static String? passwordConfirm(String? value, String password) {
    if (value == null || value.isEmpty) {
      return '비밀번호 확인을 입력해주세요';
    }

    if (value != password) {
      return '비밀번호가 일치하지 않습니다';
    }

    return null;
  }

  /// 전화번호 검증 (한국)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return '전화번호를 입력해주세요';
    }

    final phoneRegex = RegExp(r'^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$');

    if (!phoneRegex.hasMatch(value)) {
      return '올바른 전화번호 형식이 아닙니다';
    }

    return null;
  }

  /// 필수 입력 검증
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? '필수'} 항목입니다';
    }
    return null;
  }

  /// 최소 길이 검증
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? '이'} 입력해주세요';
    }

    if (value.length < minLength) {
      return '${fieldName ?? '입력값'}은 최소 $minLength자 이상이어야 합니다';
    }

    return null;
  }

  /// 최대 길이 검증
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // 빈 값은 허용
    }

    if (value.length > maxLength) {
      return '${fieldName ?? '입력값'}은 최대 $maxLength자까지 입력 가능합니다';
    }

    return null;
  }

  /// 숫자만 허용
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? '숫자'}를 입력해주세요';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return '${fieldName ?? '입력값'}은 숫자만 입력 가능합니다';
    }

    return null;
  }

  /// 금액 검증 (양수)
  static String? amount(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? '금액'}을 입력해주세요';
    }

    final amount = int.tryParse(value.replaceAll(',', ''));

    if (amount == null) {
      return '올바른 금액을 입력해주세요';
    }

    if (amount <= 0) {
      return '${fieldName ?? '금액'}은 0보다 커야 합니다';
    }

    return null;
  }

  /// 날짜 검증
  static String? date(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? '날짜'}를 입력해주세요';
    }

    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return '올바른 날짜 형식이 아닙니다';
    }
  }
}
