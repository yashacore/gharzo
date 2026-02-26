import 'package:flutter/material.dart';
import 'package:gharzo_project/model/model/project_model.dart';
import 'package:gharzo_project/screens/projects/project_details_screen.dart';


class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) =>  ProjectDetailScreen(projectId: project.id)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: _projectImage(),
                ),
                if (project.isPremium)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _badge("PREMIUM"),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    project.tagline,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 6,
                    children: [
                      _chip(project.city),
                      _chip(project.status),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "₹${project.minPrice ~/ 100000}L - ₹${project.maxPrice ~/ 100000}L",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 12,),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.grey.shade200,
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  Widget _projectImage() {
    final imageUrl = project.image;

    if (imageUrl == null ||
        imageUrl.isEmpty ||
        !imageUrl.startsWith('http')) {
      // 🔁 FALLBACK IMAGE
      return Container(
        height: 180,
        width: double.infinity,
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.image_not_supported,
          size: 48,
          color: Colors.grey,
        ),
      );
    }

    return Image.network(
      imageUrl,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 180,
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.broken_image,
            size: 48,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}