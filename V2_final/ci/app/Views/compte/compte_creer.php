<section class="page-section cta">
            <div class="container">
                <div class="row">
                    <div class="col-xl-9 mx-auto">
                        <div class="cta-inner bg-faded text-center rounded">
</br>

<h2 class="section-heading mb-4">
<span class="section-heading-lower"><?php echo $titre; ?></span></h2>

<?= session()->getFlashdata('error') ?>

</br>
<?php
// Création d’un formulaire qui pointe vers l’URL de base + /compte/creer
echo form_open('/compte/creer'); ?>
<?= csrf_field() ?>
<h5>
<label for="prenom">Prénom : </label>
<input type="input" style="width:275px;" name="prenom">
</br>

</br>
<label for="nom">Nom : </label>
<input type="input" style="width:305px;" name="nom">
</br>

</br>
<label for="pseudo">Pseudo : </label>
<input type="input" style="width:280px;" name="pseudo">
</br>

</br>
<label for="mdp">Mot de passe : </label>
<input type="password" style="width:225px;" name="mdp">
</br>

</br>
<label for="mdp2"> Validation du mot de passe : </label></br>
<input type="password" style="width:370px;" name="mdp2">
</br>


</br>
<input type="submit" class="btn btn-light btn-lg btn-block" name="submit" value="Créer un nouveau compte">
</br>
<?= validation_show_error('prenom') ?>
</br>
<?= validation_show_error('nom') ?>
</br>
<?= validation_show_error('pseudo') ?>
</br>
<?= validation_show_error('mdp') ?>

</h5>
</form>
</div></div></div></div></section>