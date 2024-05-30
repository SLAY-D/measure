PGDMP      
    
            |            testGeo    16.2    16.2     t           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            u           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            v           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            w           1262    42859    testGeo    DATABASE     }   CREATE DATABASE "testGeo" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE "testGeo";
                postgres    false                        3079    42860    postgis 	   EXTENSION     ;   CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
    DROP EXTENSION postgis;
                   false            x           0    0    EXTENSION postgis    COMMENT     ^   COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';
                        false    2            �            1259    43969    measurement    TABLE     U  CREATE TABLE public.measurement (
    id bigint NOT NULL,
    points_id integer NOT NULL,
    sensor_characteristic_id integer NOT NULL,
    sensor_type_id integer NOT NULL,
    date date,
    pm25 character varying,
    pm10 character varying,
    temperature character varying,
    pressure character varying,
    co2 character varying
);
    DROP TABLE public.measurement;
       public         heap    postgres    false            �            1259    44027    points    TABLE     �   CREATE TABLE public.points (
    id bigint NOT NULL,
    geom public.geometry(Point,3857),
    name character varying(50),
    model character varying(50)
);
    DROP TABLE public.points;
       public         heap    postgres    false    2    2    2    2    2    2    2    2            �            1259    43995    sensor_characteristic    TABLE     �   CREATE TABLE public.sensor_characteristic (
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    unit character varying(50) NOT NULL,
    data_type character varying(50) NOT NULL,
    sensor_type_id integer NOT NULL
);
 )   DROP TABLE public.sensor_characteristic;
       public         heap    postgres    false            �            1259    43984    sensor_type    TABLE     �   CREATE TABLE public.sensor_type (
    id bigint NOT NULL,
    manufacturer character varying(50) NOT NULL,
    type character varying(50) NOT NULL
);
    DROP TABLE public.sensor_type;
       public         heap    postgres    false            �            1259    50037    values    TABLE     2  CREATE TABLE public."values" (
    id integer NOT NULL,
    points_id integer,
    sensor character varying(255),
    pm25 character varying(255),
    pm10 character varying(255),
    temperature character varying(255),
    pressure character varying(255),
    co2 character varying(255),
    date date
);
    DROP TABLE public."values";
       public         heap    postgres    false            �            1259    50036    values_id_seq    SEQUENCE     �   CREATE SEQUENCE public.values_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.values_id_seq;
       public          postgres    false    226            y           0    0    values_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.values_id_seq OWNED BY public."values".id;
          public          postgres    false    225            �           2604    50040 	   values id    DEFAULT     h   ALTER TABLE ONLY public."values" ALTER COLUMN id SET DEFAULT nextval('public.values_id_seq'::regclass);
 :   ALTER TABLE public."values" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    226    225    226            l          0    43969    measurement 
   TABLE DATA           �   COPY public.measurement (id, points_id, sensor_characteristic_id, sensor_type_id, date, pm25, pm10, temperature, pressure, co2) FROM stdin;
    public          postgres    false    221   +$       o          0    44027    points 
   TABLE DATA           7   COPY public.points (id, geom, name, model) FROM stdin;
    public          postgres    false    224   �0       n          0    43995    sensor_characteristic 
   TABLE DATA           Z   COPY public.sensor_characteristic (id, name, unit, data_type, sensor_type_id) FROM stdin;
    public          postgres    false    223   �4       m          0    43984    sensor_type 
   TABLE DATA           =   COPY public.sensor_type (id, manufacturer, type) FROM stdin;
    public          postgres    false    222   �4       �          0    43178    spatial_ref_sys 
   TABLE DATA           X   COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
    public          postgres    false    217   N5       q          0    50037    values 
   TABLE DATA           g   COPY public."values" (id, points_id, sensor, pm25, pm10, temperature, pressure, co2, date) FROM stdin;
    public          postgres    false    226   k5       z           0    0    values_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.values_id_seq', 86, true);
          public          postgres    false    225            �           2606    43973    measurement measurement_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.measurement
    ADD CONSTRAINT measurement_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.measurement DROP CONSTRAINT measurement_pkey;
       public            postgres    false    221            �           2606    44031    points points_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.points
    ADD CONSTRAINT points_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.points DROP CONSTRAINT points_pkey;
       public            postgres    false    224            �           2606    43999 0   sensor_characteristic sensor_characteristic_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.sensor_characteristic
    ADD CONSTRAINT sensor_characteristic_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.sensor_characteristic DROP CONSTRAINT sensor_characteristic_pkey;
       public            postgres    false    223            �           2606    43990    sensor_type sensor_type_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.sensor_type
    ADD CONSTRAINT sensor_type_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.sensor_type DROP CONSTRAINT sensor_type_pkey;
       public            postgres    false    222            �           2606    50044    values values_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public."values"
    ADD CONSTRAINT values_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public."values" DROP CONSTRAINT values_pkey;
       public            postgres    false    226            �           2606    44034 &   measurement measurement_points_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.measurement
    ADD CONSTRAINT measurement_points_id_fkey FOREIGN KEY (points_id) REFERENCES public.points(id) NOT VALID;
 P   ALTER TABLE ONLY public.measurement DROP CONSTRAINT measurement_points_id_fkey;
       public          postgres    false    224    5585    221            �           2606    44010 5   measurement measurement_sensor_characteristic_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.measurement
    ADD CONSTRAINT measurement_sensor_characteristic_id_fkey FOREIGN KEY (sensor_characteristic_id) REFERENCES public.sensor_characteristic(id) NOT VALID;
 _   ALTER TABLE ONLY public.measurement DROP CONSTRAINT measurement_sensor_characteristic_id_fkey;
       public          postgres    false    223    221    5583            �           2606    44005 +   measurement measurement_sensor_type_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.measurement
    ADD CONSTRAINT measurement_sensor_type_id_fkey FOREIGN KEY (sensor_type_id) REFERENCES public.sensor_type(id) NOT VALID;
 U   ALTER TABLE ONLY public.measurement DROP CONSTRAINT measurement_sensor_type_id_fkey;
       public          postgres    false    222    221    5581            �           2606    44000 ?   sensor_characteristic sensor_characteristic_sensor_type_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sensor_characteristic
    ADD CONSTRAINT sensor_characteristic_sensor_type_id_fkey FOREIGN KEY (sensor_type_id) REFERENCES public.sensor_type(id) NOT VALID;
 i   ALTER TABLE ONLY public.sensor_characteristic DROP CONSTRAINT sensor_characteristic_sensor_type_id_fkey;
       public          postgres    false    223    5581    222            l   p  x�m�a�$���WqHBp	�`���%�~3U5���C#�R�)�[���k��_��V��{�Hk}�9�Y�^���en�k��Ys���Şa����3���r䘥��GcX������@@�I�^�w��#�n�(5������ۼX�;��0�=�Jڮ�+�bmt�.=�νr[ƌ=r�n��wH/c��u�Jm�Vf�m����ܴ|٬�w���&�'(�q�5Gn%�Wk�,�D�������r��]Y�>��$p�Um�d/n�Zr���8F����[������I`��Hu�|8��N4��c�����՛����G)x/Z��?�w��5?RE�����wɅ��$Z=�?��d<��|L�i��4e`)��	%����5�n�8k�
i���c���s�Xs�peE�Q��ঌﱩ�܃��	bF5����Սj~YVPE�ýu�6=�;�4&D��R��|�9FW@��{��ȣ��,jfl�;%+c	S-l����
����[q❅ٱ�߾GS@/�~C��N� �I�Z;���4�m*e9 @���մ��	hVM��mۘ�k��5�\�n[`�s���W�?�U1-G�E}�a�q�"Ӑ���?��E�n��U
����sB2�����\1��HC��W�����&96�~s���h+i�'@ ���v�\6R�EaT9i)]�+�IW� cm��nA*@�$PrpR�&��P_N8�F�f%E4`4���c��� �� 2�h��E�E��M�0$?0D1i߹�"ǌ�O8�N9�4�/�����AF�L��&�=�b[% �hM:�<�J5U��v�c�_NI��O�vIʸa� �!V�|39¤�c��Z�T��|�a}���ͨ0����R�p`N��b��|�p���MΦ��]��d��Sfu	S�(�E�"!��7u4$H_����C�x�耫e���O�I�`C$�qb��֟3�
���^�4
h�{Ç� EH�Na�U{���ix��Σ"b.�N�G�'@eR8w[T�fd�D ��CI|��C�@ԅ��p|��r.X�����ñWm{����hC'�pi�F���f�K8�{�<��$���q��U�q�`n�g�\��.��)A4���b�FO��D.�8'ej�5ؗƯ`8��,��̗'�:��pb���L�Z ��.q) !_�7(j���	C(�W���U�_����s���p�3�Ne+���l�c�W@�� ��8��C�m�0
�@���u��zJ�?���W	I$�� ���t���$c� ���A̝,�����D�h1����'�<?�<x��]��-��!'�,�����)�^���P��"��\Dz���d�n_��>�����Hh�9���%����e�Q�}�_��_ߣY{��8�Q�US{�#2(<�8ʾ�叄����~��!��801_I,5��� Ps�:��_�?��ء�E@��;�]|:�I�7��Hҫ6h3�����ٞ�x)v�o $�������ninV, `I��bU���47�JK�!ۋ��;ֵ�2�e�4h�P�̀V�mx/h��qjs�<l�qSU>�I�hjt"��խ�\��AZ���uy�6v�.3p�M^�����2� ��J���(����Y$�x�%��X#Ɛ��-���$��(�q�J.6���`t8=��s#*F1��Ϧ���[.ǧɁ��FYm�(;�gA����Sk���@����9!�v�#�5�Ҹn�|��O�rI�'�-����a�/f���1,$@��Nb�o
x�� t)ÐK��,��/~83~�)��H>�G��<A9�n�I%�D�����6��8�����q���)f��K/�f����Y��b^:S�.�Є�`�	N *����1na�1U�Hr?�����\or�K�mB2lav�yL�h'��ۓX�H�:�`�wu�q�hҢfܛvd|���D���F�'��2 ���i�2��,Yif: �%�gV&�xm�>���&!qn�)�l�|Ұu�Ȯ�S顧F&�/�'��ʃ�uHF����v�
1��zd���"03���a�[1�^�!�l�a�,�B���q$|Q�yѰר6u�0�Z@�1�[W�6��.C��	Ӭ�\��cb����@	\35�y�F�?� S<sbF��(�YXg�`$%�P�:x':����8�8�gt6�=WѬ&�. ���l��؏�Jq&U�PØr���!#B޷zzI� �	 5DwY��ףҐ��C�hΖ[2]�c����9�rI*����pIZ��x2q�Ȕ�]mȀ"�F�x=��Y��q�M�r%w$	�����-���(�#�K�6�����.���!;*�{G�44z%v�b5�9�7mM���x&H�.e�5�!$�0�MZ���9� ��f�e!��:��!��Os ��Ce�د����-�z��%�����\��C6Zφ��"�v��Cȸ�K6^N�͎�s��#�e�H��$(�?�v~sx�tj�A����#D��O�&!�/�U��4~C$T3t^V�	'��� z��D���z*�7W	I�x:��I���սP���S�GS}F��}|�F,XD���J��35n�r)���y��\��k�Fn�.�<^�GxK6�3��<V	N��x�4�mA8ԧl��]��z���i|��`Mr��Y���5WGJ�5MOp���Dȕ3_L�C4�9�ҹ���EMNL�:�_ʨ�������z6����� ���w�ץ�C� �i��M��We�OGn=@�]e�^��!��x�kFwpF]����1�vb(gh���臀#Ԓrb�q���7Gj���䉛�W�zt�nh��+<�ü@?e�m��7iP*b�}Qai#:�������^�)N�e�e��}^W��_&�~�z�;������bKzڎ=���~ʭ��f��y���T~�S��;�n��P)�^����,�W4��-�߳w�R��l����p���}�yBZ?����ۍ:�}/�O̳���9�B8�e2����{�zM��zK�~L�9��ąX�{����,ǰ������H�n��&_k�r��X���kܽ�O\���:^���3'���s����q�׷�o�Fѿ�H>����s`      o     x����n\E�מ��%lPWuU_�}]�`�&$"����� %����I06Il^��+�$���9�Qǉ-�����u���ȧ|�Pu���5�τ	0��ǐ�q"8h��y�����o��t<�o����{�»|���gw>�s{6�9�&ڱM S�j5d�>;l]-0֠��.��P=���>[w�9�68r�d.aȦ}6u�1�"a��s��%.�~��}6�b�=[8UR�%�tu1x���g�;Z���8� mB���m��6�2�L�a3�Y�X9���X��tk���[�o��'�+׫A��g�&�l����g�l�g����F�\i�N��l�NC��g����F)n�����^KPFpZ�{���Mq����警�C8/�֬l�f���pf�#k�n�^o�P���6��VQ Lj�x�99U�/�Nn|�l��[�{����3���I<"F��г���Mw�U{:��"�pݾn?�_���ۣ�X�s5M���<]A�}1(1I��N|ߤ%�j���c_���L%�=7�ڊ����0���u_�k ƛ�NT,����7��x�!�AM���̮�lpPj|-�x��q������_	���y�C�u)O>�^�ڇ1�{+SfV&��/A���6������Z	�(�rҐL��vw^�m�Z�����\�Ĥ����u�/���$ɿ�noaϒďte�U�Gzt���F�7��w��J�钗�n"�&���e���]��@ ��l��y���XͲ?lE_N�/ڋm>/�=�E�s��!/�K���V�<t�N�Sy���=s�*sMy�mB0�.󑾒�r-�'�d��s�hM��錳JUTm�I�k���3�x1}�N����o"q4�ڷ�Z6�MEnw����&�-��`�rxϕ(Ĝ3��;��X�ɂ7�o�bw���*12��\�^�	�.�����-˛),���،,t%�a\`u�5�� :̵��,�I�M^͊��w�����o�V���`����@�o��Z��b�`�      n   (   x�3��H-������,�5�3�.)��K�4����� �3�      m   H   x�3��H-������,�5�3�2�(-JUp�,�
s^�p���.6^l���bÅP)݆\1z\\\ ��      �      x������ � �      q   i  x�}�=�e5�c�U�?]���l N:�H�X K!!C��{G|�xv�}�:��㟪S�N��X�W_������ݧ����iɗ�Z�>7SO���!�3��ں5��]�ު��쳶��.���ck9��ek�>��w�����ϲ8��.�>j��.g���|w��:A5�i���Y�y�Y��eg�>)����� @ౚ�e��Y������[v�N��t�S>�B��F;�����n9�F��J��ұ����p�
wk�*�V�A���xX� �Ň��o��`��� �˥���겴����r �F������������Ҳ-��i�a�6\/M��)���h����sl�θ�1�#�}�EoO��]V `�� �_\�Kt$o>A$ڭ5uo��`��uc1��m��c��f8h��� �Ƽ���d���5����纷lDcu&TVߠRU�av ��q���'�j�E�NDHM�9��>����^�L�bN�]��tl�ʶ�^�k��Ei�)���'a񼗽1k�xl���%1��I�Ð�)8VC�Z�2K����h��Sމ�QV������̍���
��2&�wN�`0��/a�$t����<��k�6��w]`�(����	�� L�����$�����IR٘@!�+���k�������۾|x.cZ���zh��=e�z^�=v1� ��U8<rx�d^�qU�%A���|%K�#m�v���_���i�$JH��F�N��������e_}�0CMu�Խ����˟/�������?��>���^���F�LzZĪFI_����!#���Θp�{J�]�4�<��(h����_<�/��4{J���X �0��F�K:JP=��)�c��`^j\]o�k=DMxu��������`)B������1��2�*�Dap����@�K��,R���Z�/�a?�����i�(��&]�����}�C��g��y��(�s*�\=�D:k̭�C�`�ys��o�4	Ykѿ��4��S����̓��Y
c`��
�zRYF�!Q0�L2	{��l���ZX��e(���"1��ΰ���j-m�+*�vYV�9�;i$"���Ls���*�/��7&v`�2�=Fl%^��ܽT"(���N��3�M|��-��L���3���b�Fy1����S�F�U46���e�I��|xĸ;�xTy�k�5TР?S�S5�Ht�pE�G�ic�ӹ�6�a
��b��ʆ8\*з��c���~��|��Ōܐ��~B����E�A�j��iȿ�����>�擣L�R}�Z��Q�,��0������������;�c1�+>&�N����iu�F�_[E<���uQ?� ��*�!�Џ���e�hѮ~q�gq+���r���[�[p���D=TMr���qu�=v���|�ؽ�O�2�UI��ܶ��v��9���jw�Fs�dI>�_w�����l���'Ʀ�y�4�c�۶���5�tX��-E���zt�]����%RT!Mt�plP0��R4��F�	Q�EXӢ���{̪�MF��^
<Q��DIG�{3DMz�j����?��f,y>���C���Yˁ= ����Ep�� ��f	Ϛd��	�������?��o�M�     