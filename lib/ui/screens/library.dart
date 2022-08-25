import 'package:koel_player/constants/colors.dart';
import 'package:koel_player/constants/dimensions.dart';
import 'package:koel_player/models/song.dart';
import 'package:koel_player/providers/song_provider.dart';
import 'package:koel_player/ui/screens/albums.dart';
import 'package:koel_player/ui/screens/artists.dart';
import 'package:koel_player/ui/screens/downloaded.dart';
import 'package:koel_player/ui/screens/favorites.dart';
import 'package:koel_player/ui/screens/playlists.dart';
import 'package:koel_player/ui/screens/songs.dart';
import 'package:koel_player/ui/widgets/bottom_space.dart';
import 'package:koel_player/ui/widgets/song_row.dart';
import 'package:koel_player/ui/widgets/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatelessWidget {
  static const routeName = '/library';

  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SongProvider songProvider = context.watch();
    List<Song> mostPlayedSongs = songProvider.mostPlayed(limit: 10);

    List<Widget> menuItems = ListTile.divideTiles(
      context: context,
      tiles: <Widget>[
        LibraryMenuItem(
          icon: const Icon(CupertinoIcons.heart_fill, color: AppColors.red),
          label: 'Favorites',
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => const FavoritesScreen()),
          ),
        ),
        LibraryMenuItem(
          icon: CupertinoIcons.music_note_list,
          label: 'Playlists',
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => const PlaylistsScreen()),
          ),
        ),
        LibraryMenuItem(
          icon: CupertinoIcons.music_mic,
          label: 'Artists',
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => const ArtistsScreen()),
          ),
        ),
        LibraryMenuItem(
          icon: CupertinoIcons.music_albums,
          label: 'Albums',
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => const AlbumsScreen()),
          ),
        ),
        LibraryMenuItem(
          icon: CupertinoIcons.music_note,
          label: 'Songs',
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => const SongsScreen()),
          ),
        ),
        LibraryMenuItem(
          icon: CupertinoIcons.cloud_download_fill,
          label: 'Downloaded',
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => const DownloadedScreen()),
          ),
        ),
      ],
    ).toList();

    return Scaffold(
      body: CupertinoTheme(
        data: const CupertinoThemeData(
          primaryColor: Colors.white,
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            const CupertinoSliverNavigationBar(
              backgroundColor: Colors.black,
              largeTitle: LargeTitle(text: 'Library'),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(menuItems),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.horizontalPadding,
                24,
                AppDimensions.horizontalPadding,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: Heading5(text: 'Recently added'),
              ),
            ),
            mostPlayedSongs.isEmpty
                ? const SliverToBoxAdapter(child: SizedBox.shrink())
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, int index) => SongRow(song: mostPlayedSongs[index]),
                      childCount: mostPlayedSongs.length,
                    ),
                  ),
            const BottomSpace(),
          ],
        ),
      ),
    );
  }
}

class LibraryMenuItem extends StatelessWidget {
  final dynamic icon;
  final String label;
  final void Function() onTap;

  const LibraryMenuItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  })  : assert(
          icon is IconData || icon is Widget,
          'icon must be of either IconData or Widget type.',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 0,
        leading: icon is IconData ? Icon(icon, color: Colors.white54) : icon,
        title: Text(label, style: const TextStyle(fontSize: 20)),
        trailing: const Icon(
          CupertinoIcons.chevron_right,
          size: 18,
          color: Colors.white30,
        ),
      ),
    );
  }
}
