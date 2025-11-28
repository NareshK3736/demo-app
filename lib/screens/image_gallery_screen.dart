import 'package:flutter/material.dart';
import '../widgets/cacheable_image.dart';
import 'image_viewer_screen.dart';

class ImageGalleryScreen extends StatefulWidget {
  final List<String>? imageUrls;
  final String? title;

  const ImageGalleryScreen({
    super.key,
    this.imageUrls,
    this.title,
  });

  @override
  State<ImageGalleryScreen> createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  // Demo images - replace with your actual image URLs
  late List<String> _imageUrls;

  @override
  void initState() {
    super.initState();
    _imageUrls = widget.imageUrls ??
        [
          'https://picsum.photos/400/400?random=1',
          'https://picsum.photos/400/400?random=2',
          'https://picsum.photos/400/400?random=3',
          'https://picsum.photos/400/400?random=4',
          'https://picsum.photos/400/400?random=5',
          'https://picsum.photos/400/400?random=6',
          'https://picsum.photos/400/400?random=7',
          'https://picsum.photos/400/400?random=8',
          'https://picsum.photos/400/400?random=9',
          'https://picsum.photos/400/400?random=10',
          'https://picsum.photos/400/400?random=11',
          'https://picsum.photos/400/400?random=12',
        ];
  }

  void _openImageViewer(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewerScreen(
          imageUrls: _imageUrls,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Image Gallery'),
        backgroundColor: Colors.indigo,
      ),
      body: _imageUrls.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No images available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0,
              ),
              itemCount: _imageUrls.length,
              itemBuilder: (context, index) {
                return _GalleryImageItem(
                  imageUrl: _imageUrls[index],
                  index: index,
                  onTap: () => _openImageViewer(index),
                );
              },
            ),
    );
  }
}

class _GalleryImageItem extends StatelessWidget {
  final String imageUrl;
  final int index;
  final VoidCallback onTap;

  const _GalleryImageItem({
    required this.imageUrl,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'image_$index',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CacheableImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                // Gradient overlay for better text visibility
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Image ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.zoom_in,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

