<h1>Cinema Scope</h1>
<p>Cinema Scope is a Flutter app that uses the TMDB API to provide movie and TV listings. Users can search for movies and TV shows based on genre, keywords, region, release date, watch providers, voting, and much more. The app provides detailed information on each title, including trailers, images, overviews, ratings, release dates, genres, cast and crew, recommendations, keywords, runtime, more titles by the director/creator, more titles by the leading actors, similar titles, and much more. The person detail page provides images, personal details, filmography, alternative names, and useful filters to short-list the filmography. The search screen provides multi-search and infinite scrolling support.</p>
<h2>Features</h2>
<ul>
  <li>Browse movie and TV listings by various filters</li>
  <li>Search movies and TV shows using multi-search and infinite scrolling</li>
  <li>Get detailed information about each title, including trailers, images, overviews, ratings, release dates, genres, cast and crew, recommendations, keywords, runtime, more titles by the director/creator, more titles by the leading actors, similar titles, and much more</li>
  <li>Explore a person's filmography, including images, personal details, alternative names, and useful filters</li>
</ul>
<h2>Technical Features</h2>
<ul>
  <li>Developed using Flutter framework and Dart language</li>
  <li>Uses the TMDB API for data</li>
  <li>Provides search and filter functionality for the movie and TV listings</li>
  <li>Displays trailers, images, and other information on the movie and TV detail pages</li>
  <li>Shows filmography, images, personal details, and alternative names on the person detail page</li>
  <li>Implements multi-search and infinite scrolling functionality on the search page</li>
</ul>
<h2>Packages used</h2>
Some of the Flutter packages that have been used in this project are:
<ul>
  <li><a href="https://pub.dev/packages/provider">provider</a> - for State management</li>
  <li><a href="https://pub.dev/packages/infinite_scroll_pagination">infinite_scroll_pagination</a> - for infinite scrolling of paginated results</li>
  <li><a href="https://pub.dev/packages/youtube_player_flutter">youtube_player_flutter</a> - for playing Youtube trailers</li>
  <li><a href="https://pub.dev/packages/photo_view">photo_view</a> - for zooming and panning of images</li>
  <li><a href="https://pub.dev/packages/sliver_tools">sliver_tools</a> - for expanding on the usage of Slivers</li>
  <li><a href="https://pub.dev/packages/retrofit">retrofit</a> - for pulling TMDB API data</li>
  <li><a href="https://pub.dev/packages/card_swiper">card_swiper</a> - for auto-play and loop features of PageView</li>
</ul>
<h2>How to Use</h2>
<p>To use Cinema Scope, you must first create a TMDB API key by signing up at <a href="https://www.themoviedb.org/signup">TMDB</a>. Once you have a key, head into your account page, under the API section, you will see a new token listed called <b>API Read Access Token</b>. Replace the value of the `accessToken` constant in the `lib/tmdb_api.dart` file with your API Read Access Token. Then, simply run the app on your emulator or device to start browsing movies and TV shows.</p>
<h2>How to Run the App</h2>

<ol>
	<li>Clone the repository to your local machine.</li>
	<li>Open the project in your preferred IDE.</li>
	<li>Run the app on your preferred emulator or physical device.</li>
</ol>

<h2>How to Contribute</h2>

<ol>
	<li>Fork the repository.</li>
	<li>Clone the forked repository to your local machine.</li>
	<li>Create a new branch for your feature or bug fix.</li>
	<li>Make your changes and commit them.</li>
	<li>Push your changes to your forked repository.</li>
	<li>Create a pull request to the original repository.</li>
</ol>
<h2>Contributing</h2>
<p>Cinema Scope is open source and contributions are always welcome! If you find a bug or want to add a feature, simply create a new issue on the <a href="https://github.com/yourusername/cinema_scope/issues">Github repository</a> or fork the project and submit a pull request.</p>
<h2>License</h2>
<p>Cinema Scope is licensed under the MIT License. See the <a href="https://github.com/yourusername/cinema_scope/blob/main/LICENSE">LICENSE</a> file for more information.</p>
