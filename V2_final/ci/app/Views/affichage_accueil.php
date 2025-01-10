
        <section class="page-section clearfix">
            <div class="container">
                <div class="intro">
                    <img class="intro-img img-fluid mb-3 mb-lg-0 rounded" src="bootstrap/assets/img/photo.webp" />
                    <div class="intro-text left-0 text-center bg-faded p-5 rounded">
                        <h2 class="section-heading mb-4">
                            <span class="section-heading-lower">Notre Concept
                            </span>
                        </h2>
                        <p class="mb-3">Sur ce site des concours de photographie seront organiser sur différents thèmes et pour tout types de niveau.
                            Vos photos seront ensuite examiner par des photographe professionnel qui choisiront les meilleurs.
                        </p>
                       
                    </div>
                </div>
            </div>
        </section>
        <section class="page-section cta">
            <div class="container">
                <div class="row">
                    <div class="col-xl-9 mx-auto">
                        <div class="cta-inner bg-faded text-center rounded">
                            <h2 class="section-heading mb-4">
                                <span class="section-heading-lower">Actualités</span>
                            </h2>
                            
                            
                            <?php 
                            if (! empty($act) && is_array($act)){
                                echo "<table class='table table-hover'>
                            <thead>
                                <tr>
                                <th scope='col'>Titre</th>
                                <th scope='col'>Texte</th>
                                <th scope='col'>Publié par</th>
                                <th scope='col'>Le</th>
                                </tr>
                            </thead><tbody>";
                            foreach ($act as $news){
                                echo "<tr>";
                                echo "<th>";
                                echo $news["ACT_titre"];
                                echo "</th> ";
                                echo "<th>";
                                echo $news["ACT_texteActualite"];
                                echo "</th> ";
                                echo "<th>";
                                echo $news["COM_prenom"];
                                echo " ";
                                echo $news["COM_nom"];
                                echo "</th> ";
                                echo "<th>";
                                echo $news["ACT_date"];
                                echo "</th> ";
                                echo "</tr>";
                                
                            }echo "</tbody></table>";
                        }
                            
                            else{
                                echo "<p class='mb-0'>";
                                echo "Aucune actualités";
                                echo "</P>";
                            }
                            ?>
                            
                            <button type='button' class="btn btn-dark">voir plus</button>  
                        </div>
                    </div>
                </div>
            </div>
        </section>
        
        