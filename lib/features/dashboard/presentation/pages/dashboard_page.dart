import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare_app/features/dashboard/presentation/pages/contact_page.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:health_icons/health_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/asset_helper.dart';
import '../widgets/feature_table.dart';

class DashBoardPage extends ConsumerStatefulWidget {
  const DashBoardPage({super.key});

  @override
  ConsumerState<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends ConsumerState<DashBoardPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  bool _isChangeBackground = false;

  List<Map<String, dynamic>> listNoti = [
    {
      'description':
          'Mua thuốc tại nhà tiện lợi cùng tính năng mới trên ứng dụng của chúng tôi',
      'url': 'https://hih.vn/',
      'isNew': true,
    },
    {
      'description':
          'Khám bệnh trực tuyến cùng những y bác sĩ hàng đầu, không cần đến bệnh viện',
      'url': 'https://hih.vn/',
    },
  ];
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
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0pCwJuV_7SHriE0ay_CIzHTeTuk07U0BNhw&s',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 450 && !_isCollapsed) {
        setState(() => _isCollapsed = true);
      } else if (_scrollController.offset <= 450 && _isCollapsed) {
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
                  ? const [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor,
                      Colors.white,
                      Colors.white,
                    ]
                  : const [
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                    ],
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'BỆNH VIỆN ĐA KHOA QUỐC TẾ',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'HẢI PHÒNG',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  launchUrl(Uri.parse('https://hih.vn/'));
                                },
                                child: SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: FadeInImage(
                                      fit: BoxFit.cover,
                                      placeholder: AssetImage(
                                        AssetHelper.placeholder,
                                      ),
                                      image: AssetImage(
                                        AssetHelper.image('banner.png'),
                                      ),
                                    ),
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
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        buildNewService(),
                        buildQuestionAnswer(),
                        buildNews(),
                        buildImportantNotify(),
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
                                color: Colors.black.withAlpha(20),
                                blurRadius: 8,
                                offset: const Offset(0, 8),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildCollapsedIcon(
                                HealthIcons.iScheduleSchoolDateTimeFilled,
                              ),
                              _buildCollapsedIcon(
                                IconsaxPlusLinear.call,
                                onTap: () {
                                  context.push(ContactPage.path);
                                },
                              ),
                              _buildCollapsedIcon(IconsaxPlusLinear.messages_2),
                              _buildCollapsedIcon(HealthIcons.syringeOutline),
                              _buildCollapsedIcon(HealthIcons.womanOutline),
                              _buildCollapsedIcon(
                                HealthIcons
                                    .healthVulnerabilityThroughSocialDeterminantsFilled,
                              ),
                              _buildCollapsedIcon(
                                HealthIcons.blisterPillsOvalX14Outline,
                              ),
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

  Widget _buildCollapsedIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withAlpha(20),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 20),
      ),
    );
  }

  Widget buildNewService() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dịch vụ mới',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff262A37),
          ),
        ),
        const SizedBox(height: 12),
        ...newServices.map(
          (service) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
              title: Text(
                service['title'],
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                service['subtitle'],
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconsaxPlusLinear.arrow_right_3,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff262A37),
          ),
        ),
        ...questionAnswer.map(
          (question) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 1,
            color: Colors.white,
            child: ListTile(
              leading: Icon(
                question['icon'],
                color: AppTheme.primaryColor,
                size: 20,
              ),
              title: Text(
                question['title'],
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconsaxPlusLinear.arrow_right_3,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff262A37),
          ),
        ),
        SizedBox(
          height: 130,
          child: ListView.builder(
            itemCount: news.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 80,
                  height: 100,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          news[index]['icon'],
                          color: AppTheme.primaryColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        news[index]['title'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildImportantNotify() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Thông báo quan trọng',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff262A37),
          ),
        ),
        const SizedBox(height: 12),
        ...listNoti.map(
          (noti) => Stack(
            children: [
              GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse(noti['url']));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 4 * 3,
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    noti['description'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              if (noti['isNew'] == true)
                Positioned(
                  top: 0,
                  left: 5,
                  child: Container(
                    width: 60,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconsaxPlusLinear.notification,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Tin mới',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
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
          'Tin mới nhất',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff262A37),
          ),
        ),
        ...newPosts.map(
          (post) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
            color: Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FadeInImage(
                  width: 80,
                  height: 60,
                  fit: BoxFit.cover,
                  image: NetworkImage(post['image']),
                  placeholder: AssetImage(AssetHelper.placeholder),
                ),
              ),
              title: Text(
                post['title'],
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                post['date'],
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> questionAnswer = [
    {
      'title': 'Sàng lọc sức khoẻ sinh sản',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Sàng lọc đột quỵ',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
  ];

  List<Map<String, dynamic>> news = [
    {
      'title': 'Dịch vụ y tế',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Hoạt động bệnh viện',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Thông tin sức khoẻ',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Trung tâm vắc xin',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Trung tâm vắc xin',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Trung tâm vắc xin',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Trung tâm vắc xin',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Trung tâm vắc xin',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Trung tâm vắc xin',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Trung tâm vắc xin',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Trung tâm vắc xin',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Trung tâm vắc xin',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Trung tâm vắc xin',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Trung tâm vắc xin',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
    {
      'title': 'Trung tâm vắc xin',
      'icon': HealthIcons.iScheduleSchoolDateTimeFilled,
    },
  ];
  List<Map<String, dynamic>> newPosts = [
    {
      'title': 'Người đàn ông bị khối dị vật từ măng khô chiếm trọn dạ dày',
      'image':
          'https://cdn2.tuoitre.vn/thumb_w/480/471584752817336320/2025/2/15/z6320157926804b67056d5f6d46e78825094928430171c-1739608232888203533536.jpg',
      'date': '15/02/2025',
    },
    {
      'title': 'Cấp cứu xuyên đêm cứu thai phụ mang nhóm máu hiếm',
      'image':
          'https://cdn2.tuoitre.vn/thumb_w/480/471584752817336320/2025/2/15/z6320157926804b67056d5f6d46e78825094928430171c-1739608232888203533536.jpg',
      'date': '15/02/2025',
    },
    {
      'title': 'Cứu sống du khách Mỹ bị bóc tách động mạch chủ ngực',
      'image':
          'https://cdn2.tuoitre.vn/thumb_w/480/471584752817336320/2025/2/15/z6320157926804b67056d5f6d46e78825094928430171c-1739608232888203533536.jpg',

      'date': '15/02/2025',
    },
    {
      'title':
          'Danh sách người thực hành khám bệnh, chữa bệnh tại Bệnh viện Đa khoa Quốc tế Hải Phòng',
      'image':
          'https://cdn2.tuoitre.vn/thumb_w/480/471584752817336320/2025/2/15/z6320157926804b67056d5f6d46e78825094928430171c-1739608232888203533536.jpg',
      'date': '15/02/2025',
    },
  ];
}
