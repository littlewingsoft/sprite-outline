using UnityEngine;
using System.Collections;
public class lwsoft_outline : MonoBehaviour {
		private SpriteRenderer spr;
	public float size;
		void Awake(){
			spr = GetComponent<SpriteRenderer>();
			
		}
		// Use this for initialization
		void Start () {
			spr.material.shader = Shader.Find("lwsoft/outline3");
			spr.material.SetFloat( "_StepSize", size);
		}
		
		// Update is called once per frame
		void Update () {
			
		}
	}

