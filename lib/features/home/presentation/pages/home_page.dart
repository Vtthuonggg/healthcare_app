import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:health_icons/health_icons.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/asset_helper.dart';
import '../widgets/feature_table.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  bool _isChangeBackground = false;

  List<Map<String, dynamic>> newServices = [
    {
      'title': 'Cổng dịch vụ khách hàng',
      'subtitle': 'Nhanh - Tiện - Dễ dàng',
      'image':
          'https://img.freepik.com/free-photo/beautiful-young-female-doctor-looking-camera-office_1301-7807.jpg?semt=ais_rp_progressive&w=740&q=80',
    },
    {
      'title': 'Đặt lịch nhanh - Xác nhận lịch tự động',
      'subtitle': 'Xem ngay lịch khám, giờ khámn với bác sĩ ở bất cứ đâu',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0pCwJuV_7SHriE0ay_CIzHTeTuk07U0BNhw&s',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 500 && !_isCollapsed) {
        setState(() => _isCollapsed = true);
      } else if (_scrollController.offset <= 500 && _isCollapsed) {
        setState(() => _isCollapsed = false);
      }
      if (_scrollController.offset > 100 && !_isChangeBackground) {
        setState(() => _isChangeBackground = true);
      } else if (_scrollController.offset <= 100 && _isChangeBackground) {
        setState(() => _isChangeBackground = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isCollapsed ? Colors.white : AppTheme.primaryColor,
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: !_isChangeBackground
                  ? const [AppTheme.primaryColor, AppTheme.primaryColor, Colors.white, Colors.white]
                  : const [Colors.white, Colors.white, Colors.white, Colors.white],
              stops: const [0.0, 0.4, 0.4, 1.0],
            ),
          ),
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        // Background xanh cố định
                        Container(
                          height: 400,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                        ),
                        // Nội dung
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Icon(IconsaxPlusLinear.activity, color: Colors.white, size: 30),
                                  SizedBox(width: 10),
                                  Text(
                                    'Healthcare App',
                                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 160,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: FadeInImage(
                                    fit: BoxFit.cover,
                                    placeholder: AssetImage(AssetHelper.placeholder),
                                    image: AssetImage(AssetHelper.image('bg.jpg')),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const FeatureTable(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        buildNewService(),
                        buildQuestionAnswer(),
                        buildNews(),
                        buildNewPost(),
                      ]),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedSlide(
                  offset: Offset.zero,
                  duration: const Duration(milliseconds: 100),
                  // Để hiệu ứng hiện theo kiểu fade (không dùng curve cho slide):
                  curve: Curves.linear,
                  child: AnimatedOpacity(
                    opacity: _isCollapsed ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linear,
                    child: Container(
                      color: Colors.white,
                      child: SafeArea(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 8),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildCollapsedIcon(HealthIcons.iScheduleSchoolDateTimeFilled),
                              _buildCollapsedIcon(IconsaxPlusLinear.call),
                              _buildCollapsedIcon(IconsaxPlusLinear.messages_2),
                              _buildCollapsedIcon(HealthIcons.syringeOutline),
                              _buildCollapsedIcon(HealthIcons.womanOutline),
                              _buildCollapsedIcon(HealthIcons.healthVulnerabilityThroughSocialDeterminantsFilled),
                              _buildCollapsedIcon(HealthIcons.blisterPillsOvalX14Outline),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
      child: Icon(icon, color: AppTheme.primaryColor, size: 20),
    );
  }

  Widget buildNewService() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dịch vụ mới',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff262A37)),
        ),
        const SizedBox(height: 12),
        ...newServices.map(
          (service) => Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
            color: Colors.white,
            child: ListTile(
              onTap: () {},
              contentPadding: const EdgeInsets.symmetric(horizontal: 6),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FadeInImage(
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  image: NetworkImage(service['image']),
                  placeholder: AssetImage(AssetHelper.placeholder),
                ),
              ),
              title: Text(service['title'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              subtitle: Text(service['subtitle'], style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(IconsaxPlusLinear.arrow_right_3, color: AppTheme.primaryColor, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildQuestionAnswer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Câu hỏi sàng lọc sức khoẻ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff262A37)),
        ),
        ...questionAnswer.map(
          (question) => Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
            color: Colors.white,
            child: ListTile(
              leading: Icon(question['icon'], color: AppTheme.primaryColor, size: 20),
              title: Text(question['title'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(IconsaxPlusLinear.arrow_right_3, color: AppTheme.primaryColor, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Danh mục tin tức',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff262A37)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            itemCount: news.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 12),
                width: 100,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // border: Border.all(color: AppTheme.primaryColor, width: 1),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(news[index]['icon'], color: AppTheme.primaryColor, size: 50),
                    const SizedBox(height: 8),
                    Text(
                      news[index]['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildNewPost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Bài viết mới',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff262A37)),
        ),
        ...newPosts.map(
          (post) => Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
            color: Colors.white,
            child: ListTile(
              title: Text(post['title'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> questionAnswer = [
    {'title': 'Sàng lọc sức khoẻ sinh sản', 'icon': HealthIcons.iScheduleSchoolDateTimeFilled},
    {'title': 'Sàng lọc đột quỵ', 'icon': HealthIcons.iScheduleSchoolDateTimeFilled},
  ];

  List<Map<String, dynamic>> news = [
    {'title': 'Dịch vụ y tế', 'icon': HealthIcons.iScheduleSchoolDateTimeFilled},
    {'title': 'Hoạt động bệnh viện', 'icon': HealthIcons.iScheduleSchoolDateTimeFilled},
    {'title': 'Thông tin sức khoẻ', 'icon': HealthIcons.iScheduleSchoolDateTimeFilled},
    {'title': 'Trung tâm vắc xin', 'icon': HealthIcons.iScheduleSchoolDateTimeFilled},
  ];
  List<Map<String, dynamic>> newPosts = [
    {'title': 'Bài viết 1', 'icon': HealthIcons.iScheduleSchoolDateTimeFilled},
    {'title': 'Bài viết 2', 'icon': HealthIcons.iScheduleSchoolDateTimeFilled},
    {'title': 'Bài viết 3', 'icon': HealthIcons.iScheduleSchoolDateTimeFilled},
    {'title': 'Bài viết 4', 'icon': HealthIcons.iScheduleSchoolDateTimeFilled},
  ];
}
