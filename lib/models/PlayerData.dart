class PlayerData{
  String name = '';
  String email = '';
  String phonenum = '';
  bool IsCaptain = false;
  List<int> matches = [];
  List<int> CaptainthatDay = [];
  PlayerData(){
    IsCaptain = false;

    for (int i = 0; i < 32; i ++) {
      matches.add(-1);
      CaptainthatDay.add(-1);
    }
  }
}
