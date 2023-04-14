void main() {
    DateTime now = DateTime.now();
    print(now);

    Future.delayed(
	  Duration(milliseconds: 1000),
     	() {
	      DateTime now2 = DateTime.now();
	      print(now2);
	  }
    );
}