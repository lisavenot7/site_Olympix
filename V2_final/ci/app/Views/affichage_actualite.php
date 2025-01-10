<h1 class="text-white mb4" ><?php echo $titre;?></h1><br />
<?php

if (isset($news)){
    echo "<h2 class='text-white-50 mx-auto mt-2 mb-5'>";
    echo $news->ACT_idActualite;
    echo(" -- ");
    echo $news->ACT_titre;
    echo "</h2>";
}
else {
    echo ("Pas d'actualité !");
}
?>