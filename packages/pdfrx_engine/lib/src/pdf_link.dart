import 'pdf_annotation.dart';
import 'pdf_dest.dart';
import 'pdf_page.dart';
import 'pdf_rect.dart';
import 'utils/list_equals.dart';

/// Link in PDF page.
///
/// Either one of [url] or [dest] is valid (not null).
/// See [PdfPage.loadLinks].
class PdfLink {
  const PdfLink(this.rects, {this.url, this.dest, this.annotation, this.isPushButton = false});

  /// Link URL.
  final Uri? url;

  /// Link destination (link to page).
  final PdfDest? dest;

  /// Link location(s) inside the associated PDF page.
  ///
  /// Sometimes a link can span multiple rectangles, e.g., a link across multiple lines.
  final List<PdfRect> rects;

  /// Annotation information if available.
  final PdfAnnotation? annotation;

  /// Whether this link is implemented as a push button.
  ///
  /// If `true`, the link behaves like a push button that triggers a navigation event when tapped.
  /// In this case, the target ([url] or [dest]) might not be fully determined during parsing
  /// and should be resolved later. For example, at runtime when the user interacts with the button
  ///
  /// See also: [PdfDocument.destFromClickOnFormField]
  final bool isPushButton;

  /// Compact the link.
  ///
  /// The method is used to compact the link to reduce memory usage.
  /// [rects] is typically growable and also modifiable. The method ensures that [rects] is unmodifiable.
  /// [dest] is also compacted by calling [PdfDest.compact].
  PdfLink compact() {
    return PdfLink(List.unmodifiable(rects), url: url, dest: dest?.compact(), annotation: annotation, isPushButton: isPushButton);
  }

  @override
  String toString() {
    return 'PdfLink{${url?.toString() ?? dest?.toString()}, rects: $rects, annotation: $annotation, isPushButton: $isPushButton}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PdfLink &&
        other.url == url &&
        other.dest == dest &&
        listEquals(other.rects, rects) &&
        other.annotation == annotation &&
        other.isPushButton == isPushButton;
  }

  @override
  int get hashCode => url.hashCode ^ dest.hashCode ^ rects.hashCode ^ annotation.hashCode ^ isPushButton.hashCode;
}
