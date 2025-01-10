<section class="page-section cta">
            <div class="container">
                <div class="row">
                    <div class="col-xl-9 mx-auto">
                        <div class="cta-inner bg-faded text-center rounded">
</br>

<h2 class="section-heading mb-4">
<span class="section-heading-lower"><?php echo $titre; ?></span></h2>


<?= session()->getFlashdata('error') ?>
<?php echo form_open('/compte/connecter'); ?>
<?= csrf_field() ?>
</br>

<h5>
<label for="pseudo">Pseudo : </label>
<input type="input" style="width:280px;" name="pseudo">
</br>

</br>
<label for="mdp">Mot de passe : </label>
<input type="password" style="width:220px" name="mdp">
</br>

</br>
<input type="submit" class="btn btn-light btn-lg btn-block" name="submit" value="Se Connecter">
</br>
</br>
<?= validation_show_error('pseudo') ?>
</br>
<?= validation_show_error('mdp') ?>
<?php echo $t; ?></span>
</br>

</br>
Vous n'avez pas encore de compte? 
<a href="../compte/creer" ><input  class="btn btn-dark" name="submit" value="S'Inscrire"></a>

</h5>
</form>
</div></div></div></div></section>