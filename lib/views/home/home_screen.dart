import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class HomeTab extends StatelessWidget {
  final List<String> imageList = [
    'https://miro.medium.com/v2/resize:fit:700/0*jDWMNR8PFzYRoQhC.png',
    'https://www.notta.ai/pictures/voice-translator-app-05.png',
    'https://media.licdn.com/dms/image/v2/C4D1BAQF2QofATuCTgw/company-background_10000/company-background_10000/0/1583332688891/mehran_university_of_engineering_and_technology_pakistan_cover?e=2147483647&v=beta&t=jaddCD1sg4KCjrF1LtHm_MhooV1UPC4HJcYfgRPzH1E',
    'https://www.idrnd.ai/wp-content/uploads/2020/03/VoiceCloning-DataCollection-scaled.jpeg',
    'https://img.freepik.com/free-vector/voice-translator-app_23-2148621293.jpg',
    'https://s.cafebazaar.ir/images/upload/screenshot/com.ticktalk.translatevoice-304a41d8-ae54-468f-afbf-0e52745f8502.webp?x-img=v1/resize,h_600,lossless_false/optimize'
  ];

  final List<Promotion> promotions = [
    Promotion(
      title: 'New Feature: Video Filters',
      description: 'Try out our new video filters to enhance your calls!',
      imageUrl: 'https://whatfix.com/blog/wp-content/uploads/2021/11/New-product.png',
            features: ['https://amoeboids.com/wp-content/uploads/2020/08/A-Definitive-Guide-to-Announcing-New-Features-Banner.webp', 'https://cdn.prod.website-files.com/651286e75f334691f08e3fd1/66e91a02f0447e1d7c36b81a_Untitled_design_%25252820%252529.webp'],

    ),
    Promotion(
      title: 'Limited Time Offer',
      description: 'Get 20% off on premium subscriptions for the first month!',
      imageUrl: 'https://img.freepik.com/free-vector/appointment-booking-with-smartphone_23-2148554312.jpg?t=st=1738061577~exp=1738065177~hmac=bade73186fa1f8967e22c5521b5bf3cfd7f9805250ef582923b7d043ac2b956a&w=740',
            features: ['https://getthematic.com/insights/content/images/2023/05/Product-update---round-up.png', 'https://lh3.googleusercontent.com/proxy/SA1K9dOKCQJ6288N4admMs8ZgdoXnLW7_Sfe-cmseRk8QxETQKKA0h9asSaFD2aWZhP8GuwysUKXQrDfAAQ0zj9_Mi7UkxzIEII8H8gQ4uY'],

    ),
    Promotion(
      title: 'Update: Improved Chat Experience',
      description: 'Enjoy a smoother chat experience with our latest update.',
      imageUrl: 'https://img.freepik.com/free-photo/representations-user-experience-interface-design_23-2150038910.jpg?ga=GA1.1.110384691.1738056576&semt=ais_hybrid',
      features: ['https://img.freepik.com/free-photo/representations-user-experience-interface-design_23-2150038915.jpg?t=st=1738061447~exp=1738065047~hmac=52efbc21cc7c3f6796fbe6bf48601e895ce0ba3d517f9421ae284636981c28e7&w=740', 'https://img.freepik.com/free-photo/representations-user-experience-interface-design_23-2150038906.jpg?t=st=1738061478~exp=1738065078~hmac=bc420df00a9aa6ae453c2ac2a5e0ddcc6fc20fc6ae347311777bef11e8a3c95e&w=740'],

    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 10, top: 20),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Welcome to',
                      textStyle: GoogleFonts.kaushanScript(
                        fontSize: 37,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                    TypewriterAnimatedText(
                      'Voicemate',
                      textStyle: GoogleFonts.kaushanScript(
                        fontSize: 37,
                        fontWeight: FontWeight.w600,
                        color: Colors.yellowAccent,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                    TypewriterAnimatedText(
                      'app',
                      textStyle: GoogleFonts.kaushanScript(
                        fontSize: 37,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                ),
              ),
              CarouselSlider(
                items: imageList.map((url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    color: Colors.grey,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black54,
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayInterval: Duration(seconds: 3),
                  viewportFraction: 0.9,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: promotions.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 1000),
                        child: ScaleAnimation(
                          scale: 0.95,
                          child: FadeInAnimation(
                            child: PromotionCard(promotion: promotions[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Promotion {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> features; 

  Promotion({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.features,
  });
}

class PromotionCard extends StatelessWidget {
  final Promotion promotion;

  const PromotionCard({Key? key, required this.promotion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              promotion.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: Colors.grey[300],
                child: Image(
                  fit: BoxFit.cover,
                  image: const NetworkImage(
                      'https://img.freepik.com/free-vector/new-functions-concept-illustration_114360-5946.jpg'),
                ),
              ),
            ),
          ),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF00c6ff),
                  Color(0xFF0072ff),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: Text(
              promotion.title,
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              promotion.description,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        
          if (promotion.features.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Features:",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: promotion.features.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            promotion.features[index],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.broken_image,
                                size: 30,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
       
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF36d1dc), Color(0xFF5b86e5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                onPressed: () {
                  // Handle button press
                },
                child: Text(
                  'Learn More',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}