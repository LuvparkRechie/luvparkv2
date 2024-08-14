import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart';

class VoiceSearchController extends GetxController {
  final stt.SpeechToText speech = stt.SpeechToText();
  final parameters = Get.arguments;
  RxBool isListening = false.obs;
  RxString searchText = ''.obs;
  List<LocaleName> localeNames = [];
  String currentLocaleId = '';
  bool hasSpeech = false;
  String lastError = '';

  @override
  void onInit() {
    super.onInit();
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    bool available = await speech.initialize();
    if (!available) {
      Get.snackbar('Error', 'Speech recognition is not available');
    }
  }

  void startListening() async {
    if (!isListening.value) {
      await speech.listen(onResult: (result) {
        searchText.value = result.recognizedWords;
      });
      isListening.value = true;
    }
  }

  void stopListening() async {
    if (isListening.value) {
      await speech.stop();
      isListening.value = false;
    }
  }

  Future<void> initSpeechState() async {
    try {
      var hasSpeech = await speech.initialize();
      if (hasSpeech) {
        // Get the list of languages installed on the supporting platform so they
        // can be displayed in the UI for selection by the user.
        localeNames = await speech.locales();

        var systemLocale = await speech.systemLocale();
        currentLocaleId = systemLocale?.localeId ?? '';
      }

      hasSpeech = hasSpeech;
    } catch (e) {
      lastError = 'Speech recognition failed: ${e.toString()}';
      hasSpeech = false;
    }
  }

  @override
  void onClose() {
    stopListening();
    super.onClose();
  }
}
